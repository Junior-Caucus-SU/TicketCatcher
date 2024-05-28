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
        if !(validity == "Approved") {
            LogManager.shared.log("Record \(barcode) is correctly formatted but not approved. Skipping.")
            completion(nil)
        } else {
            let record = CKRecord(recordType: "Codename")
            record["Name"] = name as CKRecordValue
            record["SessionID"] = barcode as CKRecordValue
            record["Barcode"] = osis as CKRecordValue //RECORD NAME BARCODE IS ACTUALLY OSIS
            
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
                    self.fetchMoreRecords(cursor: cursor, currentRecords: newCodenames, completion: completion)
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
    
    ///Fetch more records according to the cursor location.
    private func fetchMoreRecords(cursor: CKQueryOperation.Cursor, currentRecords: [Codename], completion: @escaping ([Codename], Error?) -> Void) {
        let operation = CKQueryOperation(cursor: cursor)
        operation.resultsLimit = 200
        var newRecords = currentRecords
        
        operation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                let codename = Codename(record: record)
                newRecords.append(codename)
            case .failure(let error):
                LogManager.shared.log("Failed to fetch a record with error \(error)")
            }
        }
        
        operation.queryResultBlock = { result in
            switch result {
            case .success(let cursor):
                if let cursor = cursor {
                    self.fetchMoreRecords(cursor: cursor, currentRecords: newRecords, completion: completion)
                } else {
                    DispatchQueue.main.async {
                        completion(newRecords, nil)
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
        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = 200
        var allRecordIDs = [CKRecord.ID]()
        
        operation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                allRecordIDs.append(record.recordID)
            case .failure(let error):
                LogManager.shared.log("Failed to fetch a record with error \(error)")
            }
        }
        
        operation.queryResultBlock = { result in
            switch result {
            case .success(let cursor):
                if let cursor = cursor {
                    self.fetchMoreRecordsForDeletion(cursor: cursor, currentRecordIDs: allRecordIDs, completion: completion)
                } else {
                    self.deleteRecords(recordIDs: allRecordIDs, completion: completion)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
        
        database.add(operation)
    }
    
    ///Fetch more records according to the cursor location for deletion.
    private func fetchMoreRecordsForDeletion(cursor: CKQueryOperation.Cursor, currentRecordIDs: [CKRecord.ID], completion: @escaping (Error?) -> Void) {
        let operation = CKQueryOperation(cursor: cursor)
        operation.resultsLimit = 200
        var allRecordIDs = currentRecordIDs
        
        operation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                allRecordIDs.append(record.recordID)
            case .failure(let error):
                LogManager.shared.log("Failed to fetch a record with error \(error)")
            }
        }
        
        operation.queryResultBlock = { result in
            switch result {
            case .success(let cursor):
                if let cursor = cursor {
                    self.fetchMoreRecordsForDeletion(cursor: cursor, currentRecordIDs: allRecordIDs, completion: completion)
                } else {
                    self.deleteRecords(recordIDs: allRecordIDs, completion: completion)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
        
        database.add(operation)
    }
    
    ///Delete all records with the given record IDs.
    private func deleteRecords(recordIDs: [CKRecord.ID], completion: @escaping (Error?) -> Void) {
        let deleteOp = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordIDs)
        
        deleteOp.modifyRecordsCompletionBlock = { _, _, error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
        
        database.add(deleteOp)
    }
}