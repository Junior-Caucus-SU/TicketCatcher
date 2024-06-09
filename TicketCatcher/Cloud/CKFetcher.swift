//
//  CKFetcher.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/27/24.
//

import CloudKit

class CKFetcher {
    static let shared = CKFetcher()
    private let container = CKContainer(identifier: "iCloud.Barcodes")
    public var database: CKDatabase {
        return container.publicCloudDatabase
    }
    
    ///Fetch Total Attendees
    func fetchAttendeeCount(completion: @escaping (Int) -> Void) {
        let query = CKQuery(recordType: "Codename", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("Error fetching attendee count with error \(error.localizedDescription)")
                completion(0)
            } else if let records = records {
                print("Fetched \(records.count) attendees")
                completion(records.count)
            } else {
                print("No records...")
                completion(0)
            }
        }
    }
    
    ///Subscribe to Attendee Updates
    func subscribeToAttendeeUpdates() {
        let predicate = NSPredicate(value: true)
        let subscriptionID = "attendeeUpdates"
        let subscription = CKQuerySubscription(recordType: "Codename", predicate: predicate, subscriptionID: subscriptionID, options: [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion])
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        
        subscription.notificationInfo = notificationInfo
        
        database.save(subscription) { subscription, error in
            if let error = error {
                print("Error saving subscription with error \(error.localizedDescription)")
            } else {
                print("Subscription saved successfully")
            }
        }
    }
    
    ///Subscribe to Attendee Scan Status Updates
    func subscribeToScanStatusUpdates() {
        let predicate = NSPredicate(format: "ScanStatus == 1")
        let subscriptionID = "scanStatusUpdates"
        let subscription = CKQuerySubscription(recordType: "Codename", predicate: predicate, subscriptionID: subscriptionID, options: [.firesOnRecordUpdate])
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        
        subscription.notificationInfo = notificationInfo
        
        database.save(subscription) { subscription, error in
            if let error = error {
                print("Error saving ScanStatus subscription with error \(error.localizedDescription)")
            } else {
                print("ScanStatus subscription saved successfully")
            }
        }
    }
}
