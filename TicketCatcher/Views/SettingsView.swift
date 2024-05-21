//
//  SettingsView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/19/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("canUseFaceID") private var canUseFaceID = true
    @AppStorage("updateRecordsAutomatically") private var updateRecordsAutomatically = false
    @AppStorage("enableBackgroundFetch") private var enableBackgroundFetch = false
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Label("Account Type", systemImage: "person")) {
                    Text("Administrator")
                    Text("As an administrator, you can upload attendee lists, view logs, add individual attendees, clear all attendees, and scan tickets.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Section(header: Label("Security", systemImage: "lock.shield")) {
                    Toggle("Log In with Face ID", isOn: $canUseFaceID)
                }
                Section(header: Label("Refreshing", systemImage: "arrow.clockwise")) {
                    Toggle("Update Records Automatically", isOn: $updateRecordsAutomatically)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
