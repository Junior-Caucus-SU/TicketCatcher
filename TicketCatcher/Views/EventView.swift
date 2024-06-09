//
//  EventView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 6/6/24.
//

import SwiftUI

struct EventView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Currently Operating")
                            .font(.title2)
                            .bold()
                        Spacer()
                        Image(systemName: "person.3.sequence.fill")
                            .symbolEffect(.variableColor)
                    }
                    VStack {
                        Image("Jprom")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Junior Prom 2024")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "checkmark")
                                    .font(.headline)
                                    .foregroundStyle(.green)
                            }
                            Text("Event Ended June 6")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            + Text("th")
                                .font(.system(size: 9))
                                .foregroundStyle(.secondary)
                                .baselineOffset(6.0)
                            
                            Divider()
                                .padding(.vertical, 10)
                            HStack(alignment: .top) {
                                NavigationLink(destination: LogView()) {
                                    Label("View Logs", systemImage: "doc.text.below.ecg")
                                        .font(.subheadline)
                                }
                                NavigationLink(destination: LogView()) {
                                    Label("Manage Users", systemImage: "person.badge.shield.checkmark")
                                        .font(.subheadline)
                                }
                            }
                        }
                        .padding([.bottom, .leading, .trailing])
                        .padding(.top, 10)
                    }
                    .background(
                        Image("Jprom")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 20)
                            .opacity(0.3)
                    )
                    .cornerRadius(20)
                    
                    Spacer().frame(height: 0)
                    
                    Text("Upcoming Events")
                        .font(.title2)
                        .bold()
                    
                    VStack {
                        Image("Placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Future Event")
                                    .font(.headline)
                                    .foregroundStyle(.tertiary)
                                Spacer()
                                Image(systemName: "ellipsis")
                                    .font(.headline)
                                    .foregroundStyle(.placeholder)
                            }
                            Text("Future Date")
                                .font(.subheadline)
                                .foregroundStyle(.placeholder)
                            NavigationLink(destination: LogView()) {
                                Label("Switch & Connect to Event", systemImage: "person.wave.2")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity)
                            }
                            .cornerRadius(8)
                            .padding(.top,5)
                            .disabled(true)
                            .buttonStyle(BorderedProminentButtonStyle())
                        }
                        .padding([.bottom, .leading, .trailing])
                        .padding(.top, 10)
                    }
                    .background(
                        Image("Placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 20)
                            .opacity(0.3)
                    )
                    .cornerRadius(20)
                    
                    Spacer().frame(height: 0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {}) {
                            Text("Register")
                        }
                    }
                }
                .padding()
                Spacer()
            }
            .navigationTitle("Events")
        }
    }
}

#Preview {
    EventView()
}
