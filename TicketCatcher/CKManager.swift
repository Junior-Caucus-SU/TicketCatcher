//
//  CKManager.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/11/24.
//

import CloudKit

class CKManager {
    static let shared = CKManager()
    private let container = CKContainer(identifier: "iCloud.Barcodes")
    public var database: CKDatabase {
        return container.publicCloudDatabase
    }

    func addCodenameRecord(name: String, barcode: Int, completion: @escaping (Error?) -> Void) {
        let record = CKRecord(recordType: "Codename")
        record["Name"] = name as CKRecordValue
        record["Barcode"] = barcode as CKRecordValue

        database.save(record) { _, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("error saving record due to \(error)")
                }
                completion(error)
            }
        }
    }

    func markBarcodeAsScanned(barcode: Int, completion: @escaping (Bool) -> Void) {
        let pred = NSPredicate(format: "Barcode == %d", barcode)
        let query = CKQuery(recordType: "Codename", predicate: pred)

        database.perform(query, inZoneWith: nil) { records, error in
            guard let record = records?.first, error == nil else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }

            record["ScanStatus"] = 1
            self.database.save(record) { _, error in
                DispatchQueue.main.async {
                    completion(error == nil)
                }
            }
        }
    }
}
