//
//  EventOptionsView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 2/24/25.
//

import SwiftUI

struct ControlsView: View {
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Image(systemName: "checkmark")
                            .font(.largeTitle)
                            .symbolRenderingMode(.multicolor)
                        VStack(alignment: .leading) {
                            Text("Event Name")
                                .font(.title3).bold()
                            Text("Active Event, 200 of 314 Admitted")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: OperatorsView()) {
                        HStack {
                            Image(systemName: "shield.pattern.checkered")
                                .font(.largeTitle)
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                Text("Manage Operators")
                                    .font(.title3).bold()
                                Text("Edit the list of event operators.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    NavigationLink(destination: LogView()) {
                        HStack {
                            Image(systemName: "doc.text.below.ecg")
                                .font(.largeTitle)
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                Text("Audit Logs")
                                    .font(.title3).bold()
                                Text("View event activities on the timeline.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: EventAdminView()) {
                        HStack {
                            Image(systemName: "switch.2")
                                .font(.largeTitle)
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                Text("Admin Panel")
                                    .font(.title3).bold()
                                Text("Update the event configuration.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Event Controls")
        }
    }
}

#Preview {
    ControlsView()
}
