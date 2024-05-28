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
    @AppStorage("enableBackgroundFetch") private var enableBackgroundFetch = false
    @AppStorage("useLiveActivity") private var useLiveActivity = true
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Label("My Account", systemImage: "person")) {
                    Text("Administrator")
                        .badge("Active")
                    Text("As an administrator, you can upload attendee lists, view logs, add individual attendees, clear all attendees, and scan tickets.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Section(header: Label("Security", systemImage: "lock.shield")) {
                    Toggle("Log In with Face ID", isOn: $canUseFaceID)
                    Toggle("Always Require Log In", isOn: $canUseFaceID)
                }
                Section(header: Label("Synchronization", systemImage: "arrow.clockwise")) {
                    Toggle("Live Activity", isOn: $useLiveActivity)
                    Toggle("Notify Changes", isOn: $notifyChanges)
                    
                    Picker("Event Logging", selection: $logType) {
                        Text("On Device").tag(LogType.onDevice)
                        Text("Event").tag(LogType.event)
                    }
                    
                    Text("On Device logging stores all logs locally for actions from this device only. Event logging stores all logs from all devices connected to this event in one database.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Section(header: Label("User Permissions", systemImage: "checkmark.seal")) {
                    Toggle("Scan Tickets", isOn: $canUseFaceID)
                    Toggle("Upload Lists", isOn: $canUseFaceID)
                    Toggle("Adjust Schemas", isOn: $canUseFaceID)
                    Toggle("Manually Add Records", isOn: $canUseFaceID)
                    Toggle("Reset All Records", isOn: $canUseFaceID)
                }
                Section(header: Label("Invited Users", systemImage: "checkmark.seal")) {
                    Text("TicketCatcher is in beta. To request a new user slot or create a new event, please call 929-519-5260.")
                }
                Section(header: Label("Custom Sendgrid API Key", systemImage: "paperplane")) {
                    TextField("API Key", text: $key)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
