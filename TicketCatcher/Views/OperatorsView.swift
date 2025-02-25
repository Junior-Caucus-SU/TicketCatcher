//
//  EventOptionsView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 2/24/25.
//

import SwiftUI

struct OperatorsView: View {
    @State private var start: Date = Date()
    @State private var end: Date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink(destination: SchemaTotalView()) {
                        HStack {
                            Image(systemName: "shield.pattern.checkered")
                                .font(.largeTitle)
                                .foregroundStyle(.blue)
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                Text("Administrators")
                                    .font(.title3).bold()
                                Text("Access all functionality. Invite operators, send tickets, and more")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                
                    NavigationLink(destination: SchemaTotalView()) {
                        HStack {
                            Image(systemName: "pencil.and.list.clipboard")
                                .font(.largeTitle)
                                .foregroundStyle(.orange)
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                Text("Managers")
                                    .font(.title3).bold()
                                Text("Scan tickets, alter ticket statuses, edit event details, and more")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: SchemaTotalView()) {
                        HStack {
                            Image(systemName: "barcode.viewfinder")
                                .font(.largeTitle)
                                .foregroundStyle(.teal)
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                Text("Operators")
                                    .font(.title3).bold()
                                Text("Scan tickets, view logs, and access the attendee list")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Manage Operators")
        }
    }
}

#Preview {
    OperatorsView()
}
