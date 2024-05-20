//
//  ListSheetView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 2/12/24.
//

import SwiftUI
import CloudKit

struct ListView: View {
    @State private var codenames = [Codename]()
    @State private var showAddSheet = false
    @State private var showingDeletion = false
    @State private var showUploadSheet = false
    @State private var searchText = ""
    @State private var isDeleting = false
    let codeFont = Font
        .system(size: 14)
        .monospaced()
    
    var body: some View {
        NavigationStack {
            List(filteredCodes, id: \.self) { codename in
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
                        .foregroundColor(.accentColor)
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
                ToolbarItem(placement: .navigation){
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
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search")
            .onAppear(perform: loadData)
            .scrollContentBackground(.hidden)
        }
        .sheet(isPresented: $showAddSheet) {
            AddSheet()
                .presentationBackground(.thickMaterial)
        }
        .sheet(isPresented: $showUploadSheet) {
            UploadSheet()
                .presentationBackground(.thickMaterial)
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
    
    private var filteredCodes: [Codename] {
        if searchText.isEmpty {
            return codenames
        } else {
            return codenames.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    private var totalCount: Int {
        codenames.count
    }
    
    private var scannedCount: Int {
        codenames.filter { $0.scanStatus == 1 }.count
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
    let scanStatus: Int
    
    init(record: CKRecord) {
        self.scanStatus = record["ScanStatus"] as? Int ?? 0
        self.name = record["Name"] as? String ?? "Unknown"
        self.barcode = record["Barcode"] as? Int ?? 0
    }
}

#Preview {
    ListView()
}
