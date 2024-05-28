//
//  SettingsView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/19/24.
//

import SwiftUI

enum LogType: String, CaseIterable, Identifiable {
    case onDevice, event
    var id: Self {self}
}

struct SettingsView: View {
    @State private var logType: LogType = .onDevice
    @State private var key = ""
    @AppStorage("canUseFaceID") private var canUseFaceID = true
    @AppStorage("notifyChanges") private var notifyChanges = true
    @AppStorage("useAutoRefresh") private var useAutoRefresh = true
    @AppStorage("useLiveActivity") private var useLiveActivity = true
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Label("My Account", systemImage: "person")) {
                    Text("Administrator")
                        .badge("Active")
                    Toggle("Log In with Face ID", isOn: $canUseFaceID)
                }
                
                Section(header: Label("Synchronization", systemImage: "arrow.clockwise")) {
                    Toggle("Refresh Automatically", isOn: $useAutoRefresh)
                    Toggle("Use Live Activity", isOn: $useLiveActivity)
                    Toggle("Notify Changes", isOn: $notifyChanges)
                    
                    Picker("Event Logging", selection: $logType) {
                        Text("On Device").tag(LogType.onDevice)
                        Text("Connected Event").tag(LogType.event)
                    }
                }
                
                Section(header: Label("Custom Sendgrid API Key", systemImage: "paperplane")) {
                    TextField("API Key", text: $key)
                }
                
                Text("TicketCatcher is in beta. To request a new user slot or create a new event, please call 929-519-5260.")
                    .font(.subheadline)
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
