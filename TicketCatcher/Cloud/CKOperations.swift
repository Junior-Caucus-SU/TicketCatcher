//
//  CKOperations.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/11/24.
//

import CloudKit

///Fetch and delete records with pagination (helper)
class CKOperations {
    static func fetchRecords(query: CKQuery, resultsLimit: Int, database: CKDatabase, completion: @escaping ([Codename], Error?) -> Void) {
        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = resultsLimit
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
            handleQueryResult(result: result, currentRecords: newCodenames, database: database, completion: completion)
        }
        database.add(operation)
    }
    
    ///Handle querying
    private static func handleQueryResult(result: Result<CKQueryOperation.Cursor?, Error>, currentRecords: [Codename], database: CKDatabase, completion: @escaping ([Codename], Error?) -> Void) {
        switch result {
        case .success(let cursor):
            if let cursor = cursor {
                fetchMoreRecords(cursor: cursor, currentRecords: currentRecords, database: database, completion: completion)
            } else {
                DispatchQueue.main.async {
                    completion(currentRecords, nil)
                }
            }
        case .failure(let error):
            DispatchQueue.main.async {
                completion([], error)
            }
        }
    }
    
    ///Fetch more records according to the cursor location
    private static func fetchMoreRecords(cursor: CKQueryOperation.Cursor, currentRecords: [Codename], database: CKDatabase, completion: @escaping ([Codename], Error?) -> Void) {
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
            handleQueryResult(result: result, currentRecords: newRecords, database: database, completion: completion)
        }
        database.add(operation)
    }
    
    ///Fetch records for deletion with pagination
    static func fetchRecordsForDeletion(query: CKQuery, resultsLimit: Int, database: CKDatabase, completion: @escaping (Error?) -> Void) {
        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = resultsLimit
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
            handleQueryResultForDeletion(result: result, currentRecordIDs: allRecordIDs, database: database, completion: completion)
        }
        database.add(operation)
    }
    
    ///Handle query results for deletion
    private static func handleQueryResultForDeletion(result: Result<CKQueryOperation.Cursor?, Error>, currentRecordIDs: [CKRecord.ID], database: CKDatabase, completion: @escaping (Error?) -> Void) {
        switch result {
        case .success(let cursor):
            if let cursor = cursor {
                fetchMoreRecordsForDeletion(cursor: cursor, currentRecordIDs: currentRecordIDs, database: database, completion: completion)
            } else {
                deleteRecords(recordIDs: currentRecordIDs, database: database, completion: completion)
            }
        case .failure(let error):
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    ///Fetch more records according to the cursor location for deletion
    private static func fetchMoreRecordsForDeletion(cursor: CKQueryOperation.Cursor, currentRecordIDs: [CKRecord.ID], database: CKDatabase, completion: @escaping (Error?) -> Void) {
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
            handleQueryResultForDeletion(result: result, currentRecordIDs: allRecordIDs, database: database, completion: completion)
        }
        database.add(operation)
    }
    
    ///Delete all records with the given record IDs
    private static func deleteRecords(recordIDs: [CKRecord.ID], database: CKDatabase, completion: @escaping (Error?) -> Void) {
        let deleteOp = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordIDs)
        deleteOp.modifyRecordsResultBlock = { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        }
        database.add(deleteOp)
    }
}
