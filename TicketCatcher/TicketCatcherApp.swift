//
//  TicketCatcherApp.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 10/28/23.
//

import SwiftUI
import LocalAuthentication

enum EventType: String, CaseIterable, Identifiable {
    case jprom, testing, dreams
    var id: Self { self }
}

@main
struct TicketCatcherApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var entered = false
    @State private var attemptingToEnter = false
    
    init() {
        UserDefaults.standard.register(defaults: [
            "canUseFaceID": true,
            "notifyChanges": true,
            "useAutoRefresh": true,
            "useLiveActivity": true
        ])
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if !entered {
                    EntrantView(entered: $entered, attemptingToEnter: $attemptingToEnter)
                        .transition(.blurReplace)
                } else {
                    ContentView()
                        .transition(.blurReplace)
                }
            }
            .animation(.smooth, value: entered)
        }
    }
}
