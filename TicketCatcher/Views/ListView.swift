//
//  ListSheetView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 2/12/24.
//

import SwiftUI
import CloudKit
import Combine

enum SortOrder: String, CaseIterable {
    case nameAscending = "Name Ascending"
    case nameDescending = "Name Descending"
    case scanStatus = "Admission Status"
}

struct ListView: View {
    @State private var codenames = [Codename]()
    @State private var showAddSheet = false
    @State private var showingDeletion = false
    @State private var showUploadSheet = false
    @State private var searchText = ""
    @State private var isDeleting = false {
        didSet {
            if !isDeleting {
                loadData()
            }
        }
    }
    @State private var sortOrder: SortOrder = .nameAscending
    @State private var subscription: AnyCancellable? = nil
    
    let codeFont = Font
        .system(size: 14)
        .monospaced()
    
    var body: some View {
        NavigationStack {
            if totalCount == 0 {
                VStack {
                    Image(systemName: "person.crop.circle.dashed")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .foregroundStyle(.tertiary)
                    Text("No attendees added for this event")
                        .font(.headline)
                        .padding()
                        .foregroundStyle(.tertiary)
                }
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Text("0/0")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            Button(action: {
                                showAddSheet.toggle()
                            }) {
                                Label("Add Attendee", systemImage: "plus.circle")
                            }
                            Button(action: {
                                showUploadSheet.toggle()
                            }) {
                                Label("Upload CSV", systemImage: "arrow.up.doc")
                            }
                            Divider()
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
                .navigationTitle("Attendees")
                .onAppear(perform: setup)
                .refreshable {
                    loadData()
                }
            } else {
                List(sortedFilteredCodes, id: \.self) { codename in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(codename.name)
                                .font(.headline)
                            Text("\(codename.barcode)".prefix(3) + "xxxxxx")
                                .font(codeFont)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: codename.scanStatus == 1 ? "person.fill.checkmark" : "ticket")
                            .foregroundColor(codename.scanStatus == 1 ? .orange : .accentColor)
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            CKManager.shared.markBarcodeAsScanned(barcode: codename.sessionID) { success, error in
                                if success {
                                    loadData()
                                } else if let error = error {
                                    LogManager.shared.log("Error marking barcode as scanned with error \(error) for \(codename.sessionID)")
                                }
                            }
                        } label: {
                            Label("Admit", systemImage: "checkmark.circle")
                        }
                        .tint(.green)
                    }
                }
                .navigationTitle("Attendees")
                .confirmationDialog(
                    "Delete All Records",
                    isPresented: $showingDeletion
                ) {
                    Button("Remove All Records", role: .destructive) {
                        isDeleting = true
                        CKManager.shared.removeAllCodenames() { error in
                            LogManager.shared.log("Removing all records")
                            if let error = error {
                                LogManager.shared.log("Could not remove all records with error \(error)")
                            } else {
                                LogManager.shared.log("Removed all records")
                            }
                            isDeleting = false
                        }
                    }
                } message: {
                    Text("Are you sure you want to remove all attendee records? This is not reversible.")
                }
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Text("\(scannedCount)/\(totalCount)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            Button(action: {
                                showAddSheet.toggle()
                            }) {
                                Label("Add Attendee", systemImage: "plus.circle")
                            }
                            Button(action: {
                                showUploadSheet.toggle()
                            }) {
                                Label("Upload CSV", systemImage: "arrow.up.doc")
                            }
                            Divider()
                            Button(role: .destructive) {
                                showingDeletion.toggle()
                            } label: {
                                Label("Clear Attendees", systemImage: "trash")
                            }
                            Divider()
                            Picker("Sort By", selection: $sortOrder) {
                                ForEach(SortOrder.allCases, id: \.self) { sortOrder in
                                    Text(sortOrder.rawValue).tag(sortOrder)
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search by First Name")
                .onAppear(perform: setup)
                .refreshable {
                    loadData()
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddSheet()
                .presentationBackground(.thickMaterial)
                .onDisappear {
                    loadData()
                }
        }
        .sheet(isPresented: $showUploadSheet) {
            UploadSheet()
                .presentationBackground(.thickMaterial)
                .onDisappear {
                    loadData()
                }
        }
        .overlay {
            if isDeleting {
                Rectangle()
                    .fill(.thinMaterial)
                    .overlay(
                        VStack {
                            Image(systemName: "square.stack.3d.down.right")
                                .symbolEffect(.variableColor)
                                .imageScale(.large)
                                .padding()
                            Text("Resetting the Database")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(.bottom, 7.5)
                            Text("Everyone scanning for this event should temporarily stop using the app while we clear all the records. This will take a minute...")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 30.0)
                            Spacer()
                                .frame(height: 50)
                        }
                    )
            }
        }
        .ignoresSafeArea()
    }
    
    private var sortedFilteredCodes: [Codename] {
        let filtered = searchText.isEmpty ? codenames : codenames.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        
        switch sortOrder {
        case .nameAscending:
            return filtered.sorted { $0.name < $1.name }
        case .nameDescending:
            return filtered.sorted { $0.name > $1.name }
        case .scanStatus:
            return filtered.sorted { $0.scanStatus > $1.scanStatus }
        }
    }
    
    private var totalCount: Int {
        codenames.count
    }
    
    private var scannedCount: Int {
        codenames.filter { $0.scanStatus == 1 }.count
    }
    
    private func setup() {
        loadData()
        subscription = NotificationCenter.default.publisher(for: .attendeeUpdates)
            .sink { _ in
                loadData()
            }
    }
    
    private func loadData() {
        CKManager.shared.fetchCodenames { codenames, error in
            if let error = error {
                LogManager.shared.log("Error fetching codenames with error \(error)")
            } else {
                self.codenames = codenames
            }
        }
    }
}

struct Codename: Hashable {
    let name: String
    let barcode: Int
    let sessionID: String
    let scanStatus: Int
    
    init(record: CKRecord) {
        self.scanStatus = record["ScanStatus"] as? Int ?? 0
        self.name = record["Name"] as? String ?? "Unknown"
        self.barcode = record["Barcode"] as? Int ?? 0
        self.sessionID = record["SessionID"] as? String ?? "Unknown"
    }
}

extension Notification.Name {
    static let attendeeUpdates = Notification.Name("attendeeUpdates")
}

#Preview {
    ListView()
}
