//
//  BarcodeValidator.swift
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
        
        CKManager.shared.database.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 1) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (records, _)):
                    if let _ = records.first {
                        LogManager.shared.log("\(barcode) is a valid ticket")
                        completion(true)
                    } else {
                        LogManager.shared.log("\(barcode) is an invalid ticket or already scanned")
                        completion(false)
                    }
                case .failure(let error):
                    LogManager.shared.log("Error querying records \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
}

