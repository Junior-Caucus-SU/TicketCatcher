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

    var body: some View {
        NavigationView {
            List(codenames, id: \.self) { codename in
                VStack(alignment: .leading) {
                    Text(codename.name)
                        .font(.headline)
                    Text("\(codename.barcode)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Attendees")
            .onAppear(perform: loadData)
            .scrollContentBackground(.hidden)
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
                print("cant fetch records with reason \(String(describing: error))")
                print("cant fetch records with reason \(String(describing: error))")
            }
        }
    }
}

struct Codename: Hashable {
    let name: String
    let barcode: Int

    init(record: CKRecord) {
        self.name = record["Name"] as? String ?? "Unknown"
        self.barcode = record["Barcode"] as? Int ?? 0
    }
}

#Preview {
    ListSheetView()
}
