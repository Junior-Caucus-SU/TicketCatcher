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
                    LogManager.shared.log("Error saving a record due to \(error)")
                }
                completion(error)
            }
        }
    }
    
    func fetchCodenames(completion: @escaping ([Codename], Error?) -> Void) {
        let query = CKQuery(recordType: "Codename", predicate: NSPredicate(value: true))
        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = 200
        var newCodenames = [Codename]()
        
        operation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                let codename = Codename(record: record)
                newCodenames.append(codename)
            case .failure(let error):
                LogManager.shared.log("Failed to fetch a record with error \(error)")
            }
        }
        
        operation.queryResultBlock = { result in
            switch result {
            case .success(let cursor):
                if let cursor = cursor {
                    self.fetchMoreCodenames(cursor: cursor, currentCodenames: newCodenames, completion: completion)
                } else {
                    DispatchQueue.main.async {
                        completion(newCodenames, nil)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        
        database.add(operation)
    }
    
    private func fetchMoreCodenames(cursor: CKQueryOperation.Cursor, currentCodenames: [Codename], completion: @escaping ([Codename], Error?) -> Void) {
        let operation = CKQueryOperation(cursor: cursor)
        operation.resultsLimit = 200
        var newCodenames = currentCodenames
        
        operation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                let codename = Codename(record: record)
                newCodenames.append(codename)
            case .failure(let error):
                LogManager.shared.log("Failed to fetch a record with error \(error)")
            }
        }
        
        operation.queryResultBlock = { result in
            switch result {
            case .success(let cursor):
                if let cursor = cursor {
                    self.fetchMoreCodenames(cursor: cursor, currentCodenames: newCodenames, completion: completion)
                } else {
                    DispatchQueue.main.async {
                        completion(newCodenames, nil)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        database.add(operation)
    }
    
    func markBarcodeAsScanned(barcode: Int, completion: @escaping (Bool, String?) -> Void) {
        LogManager.shared.log("Marking barcode as scanned")
        let pred = NSPredicate(format: "Barcode == %d", barcode)
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
}
