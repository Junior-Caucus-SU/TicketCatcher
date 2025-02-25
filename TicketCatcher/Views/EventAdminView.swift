//
//  EventOptionsView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 2/24/25.
//

import SwiftUI

struct EventAdminView: View {
    @State private var start: Date = Date()
    @State private var end: Date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading) {
                        DatePicker(
                            "Start Date",
                            selection: $start
                        )
                        .datePickerStyle(.compact)
                        .padding(.vertical, 5)
                        
                        Text("The event will not be accessible to non-admins before this date. Tickets scanned before this date will not be marked used.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.bottom, 5)
                    
                    VStack(alignment: .leading) {
                        DatePicker(
                            "End Date",
                            selection: $end
                        )
                        .datePickerStyle(.compact)
                        .padding(.vertical, 5)
                        
                        Text("At this date, the event will be archived. No more tickets may be scanned, and all operators will be removed.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.bottom, 5)
                }
                
                Section(
                    header: Label(
                        "Ticket Recognition Schemas",
                        systemImage: "pencil.and.list.clipboard"
                    ),
                    footer: Text("Create or use an exisiting ticket schema. This will allow you to import tickets in batch from a custom CSV file.")
                ) {
                    NavigationLink(destination: SchemaTotalView()) {
                        Text("Manage Local Schemas")
                    }
                }
                
                Section(footer: Text("Immediately unmark all scanned tickets so they may be used again. This action cannot be undone.")) {
                    Button("Unmark Scanned Tickets", role: .destructive) {
                    }
                }
                
                Section(footer: Text("Immediately end this event and archive it. This action cannot be undone.")) {
                    Button("Immediately End Event", role: .destructive) {
                    }
                }
                
            }
            .navigationTitle("Admin Panel")
        }
    }
}

#Preview {
    EventAdminView()
}
