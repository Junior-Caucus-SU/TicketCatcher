//
//  AppDelegate.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/27/24.
//

import UIKit
import UserNotifications
import CloudKit
import ActivityKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let notification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo)
        
        if let subscriptionID = notification?.subscriptionID {
            switch subscriptionID {
            case "attendeeUpdates":
                handleLiveActivityUpdate(notification: notification)
            case "scanStatusUpdates":
                handleScanStatusUpdate(notification: notification)
            default:
                break
            }
        }
        completionHandler(.newData)
    }
    
    private func handleLiveActivityUpdate(notification: CKQueryNotification?) {
        guard notification?.recordID != nil else { return }
        CKFetcher.shared.fetchAttendeeCount { count in
            let activityAttributes = LiveCountAttributes(eventName: "TicketCatcher Session")
            let initialContentState = LiveCountAttributes.ContentState(attendeeCount: count)
            Task {
                if let activity = Activity<LiveCountAttributes>.activities.first {
                    await activity.update(using: initialContentState)
                }
            }
        }
    }
    
    private func handleScanStatusUpdate(notification: CKQueryNotification?) {
        guard let recordID = notification?.recordID else { return }
        
        CKFetcher.shared.database.fetch(withRecordID: recordID) { record, error in
            guard let record = record, error == nil else {
                print("Error fetching record with error \(error?.localizedDescription ?? "unknown")")
                return
            }
            
            if let itemName = record["Name"] as? String {
                let content = UNMutableNotificationContent()
                content.title = "Ticket Scanned In"
                content.body = "The scan status of \(itemName)'s ticket has been updated."
                content.sound = UNNotificationSound.default
                content.categoryIdentifier = "scanStatusCategory"
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error adding notification \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
