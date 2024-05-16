//
//  ListSheetView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 2/12/24.
//

import SwiftUI
import CloudKit

struct ListSheetView: View {
    @State private var codenames = [Codename]()
    @State private var showRemoveSheet = false
    @State private var searchText = ""
    let codeFont = Font
        .system(size: 14)
        .monospaced()
    
    var body: some View {
        NavigationView {
            List(filteredCodes, id: \.self) { codename in
                HStack {
                    VStack(alignment: .leading) {
                        Text(codename.name)
                            .font(.headline)
                        Text("\(codename.barcode)".prefix(3) + "xxxxxx")
                            .font(codeFont)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: codename.scanStatus == 1 ? "person.fill.checkmark" : "ticket")
                        .foregroundColor(.accentColor)
                }
            }
            .navigationTitle("Attendees")
            .toolbar {
                ToolbarItem(placement: .status) {
                    HStack {
                        Text("\(scannedCount) Scanned Tickets of \(totalCount) Total").bold()
                        Image(systemName: "person.fill.checkmark")
                    }.foregroundColor(.accentColor)
                }
                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        showRemoveSheet.toggle()
                    } label: {
                        Image(systemName: "trash")
                        Text("Remove All")
                    }.foregroundColor(.red)
                }
            }
            .searchable(text: $searchText, prompt: "Search")
            .onAppear(perform: loadData)
            .scrollContentBackground(.hidden)
        }
        .sheet(isPresented: $showRemoveSheet) {
            RemoveSheetView()
                .presentationBackground(.thickMaterial)
        }
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
    ListSheetView()
}
