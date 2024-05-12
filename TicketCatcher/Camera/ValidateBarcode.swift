//
//  ValidateBarcode.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 2/28/24.
//

import Foundation
import CloudKit

struct BarcodeValidator {
    ///Validates a barcode by checking if it exists in the database and hasn't been scanned yet
    static func validate(barcode: Int, completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(format: "Barcode == %d AND ScanStatus != 1", barcode)
        let query = CKQuery(recordType: "Codename", predicate: predicate)
        
        CKManager.shared.database.perform(query, inZoneWith: nil) { records, error in
            DispatchQueue.main.async {
                guard error == nil, let records = records, !records.isEmpty else {
                    if let error = error {
                        print("Error querying records \(error.localizedDescription)")
                    } else {
                        print("\(barcode) is an invalid ticket or already scanned")
                    }
                    completion(false)
                    return
                }
                print("\(barcode) is a valid ticket")
                completion(true)
            }
        }
    }
}

