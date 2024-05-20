//
//  SettingsView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/19/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("canUseFaceID") private var canUseFaceID = true
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Enable Face ID", isOn: $canUseFaceID)
                    Text("Use Face ID to log in to TicketCatcher.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
