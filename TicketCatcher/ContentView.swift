//
//  ContentView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 10/28/23.
//

import SwiftUI
import ActivityKit
import UserNotifications

struct ContentView: View {
    var body: some View {
        TabView {
            ScanView()
                .tabItem {
                    Label("Scan", systemImage: "barcode.viewfinder")
                }
            ListView()
                .tabItem {
                    Label("Manage", systemImage: "person.crop.rectangle.stack")
                }
            EventView()
                .tabItem {
                    Label("Events", systemImage: "party.popper")
                }
            DistributeView()
                .tabItem {
                    Label("SendIt", systemImage: "paperplane")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .onAppear {
            startLiveActivity()
            requestNotificationPermission()
        }
    }
    
    func startLiveActivity() {
        CKFetcher.shared.fetchAttendeeCount { count in
            let initialContentState = LiveCountAttributes.ContentState(attendeeCount: count)
            let activityAttributes = LiveCountAttributes(eventName: "TicketCatcher Session")
            let activityContent = ActivityContent(state: initialContentState, staleDate: nil)
            do {
                let activity = try Activity<LiveCountAttributes>.request(attributes: activityAttributes, content: activityContent, pushType: nil)
                print("Live activity started with ID \(activity.id)")
                
                // Listen for updates from CloudKit
                CKFetcher.shared.subscribeToAttendeeUpdates()
                CKFetcher.shared.subscribeToScanStatusUpdates()
            } catch {
                print("Failed to start live activity \(error.localizedDescription)")
            }
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permission \(error.localizedDescription)")
            } else {
                print("Notification permission granted \(granted)")
            }
        }
    }
}

#Preview {
    ContentView()
}
