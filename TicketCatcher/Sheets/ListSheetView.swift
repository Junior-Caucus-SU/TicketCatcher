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
            .searchable(text: $searchText, prompt: "Search")
            .onAppear(perform: loadData)
            .scrollContentBackground(.hidden)
        }
    }
    
    private var filteredCodes: [Codename] {
        if searchText.isEmpty {
            return codenames
        } else {
            return codenames.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    private func loadData() {
        let query = CKQuery(recordType: "Codename", predicate: NSPredicate(value: true))
        CKManager.shared.database.perform(query, inZoneWith: nil) { (records, error) in
            if let records = records {
                DispatchQueue.main.async {
                    self.codenames = records.map { Codename(record: $0) }
                }
            } else {
                LogManager.shared.log("Can't fetch records with reason \(String(describing: error))")
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
