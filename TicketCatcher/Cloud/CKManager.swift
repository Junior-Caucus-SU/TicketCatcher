//
//  CKManager.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/11/24.
//

import CloudKit

///CloudKit operations should be done by calling this.
class CKManager {
    static let shared = CKManager()
    private let container = CKContainer(identifier: "iCloud.Barcodes")
    public var database: CKDatabase {
        return container.publicCloudDatabase
    }
    
    ///Add a codename record with provided name, barcode, and validity
    func addCodenameRecord(name: String, osis: Int, validity: String, barcode: String, completion: @escaping (Error?) -> Void) {
        if (validity != "Approved") {
            LogManager.shared.log("Record \(barcode) is correctly formatted but not approved. Skipping.")
            completion(nil)
        } else {
            let record = CKRecord(recordType: "Codename")
            record["Name"] = name as CKRecordValue
            record["SessionID"] = barcode as CKRecordValue
            record["Barcode"] = osis as CKRecordValue // RECORD NAME BARCODE IS ACTUALLY OSIS
            
            database.save(record) { _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        LogManager.shared.log("Error saving a record due to \(error)")
                    }
                    completion(error)
                }
            }
        }
    }
    
    ///Fetch a list of all codenames.
    func fetchCodenames(completion: @escaping ([Codename], Error?) -> Void) {
        let query = CKQuery(recordType: "Codename", predicate: NSPredicate(value: true))
        CKOperations.fetchRecords(query: query, resultsLimit: 200, database: database, completion: completion)
    }
    
    ///Fetch a codename for a specific barcode.
    func fetchCodename(for barcode: String, completion: @escaping (Codename?, Error?) -> Void) {
        let predicate = NSPredicate(format: "SessionID == %@", barcode)
        let query = CKQuery(recordType: "Codename", predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                completion(nil, error)
            } else if let record = records?.first {
                let codename = Codename(record: record)
                completion(codename, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    ///Mark the selected barcode as scanned.
    func markBarcodeAsScanned(barcode: String, completion: @escaping (Bool, String?) -> Void) {
        LogManager.shared.log("Marking barcode as scanned")
        let pred = NSPredicate(format: "SessionID == %@", barcode)
        let query = CKQuery(recordType: "Codename", predicate: pred)
        
        database.perform(query, inZoneWith: nil) { records, error in
            guard let record = records?.first, error == nil else {
                DispatchQueue.main.async {
                    completion(false, error?.localizedDescription ?? "Unknown error querying")
                }
                return
            }
            
            record["ScanStatus"] = 1
            self.database.save(record) { _, markScannedError in
                DispatchQueue.main.async {
                    completion(markScannedError == nil, markScannedError?.localizedDescription)
                }
            }
        }
    }
    
    ///Remove all codenames.
    func removeAllCodenames(completion: @escaping (Error?) -> Void) {
        let query = CKQuery(recordType: "Codename", predicate: NSPredicate(value: true))
        CKOperations.fetchRecordsForDeletion(query: query, resultsLimit: 200, database: database, completion: completion)
    }
}
