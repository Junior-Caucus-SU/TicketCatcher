//
//  TicketCatcherApp.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 10/28/23.
//

import SwiftUI
import LocalAuthentication

@main
struct TicketCatcherApp: App {
    @State private var entered = false
    @State private var attemptingToEnter = false
    
    init() {
        UserDefaults.standard.register(defaults: [
            "canAndMustUseFaceID": true,
            "notifyChanges": true,
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
