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
                        Spacer()
                        Image(systemName: "person.3.sequence.fill")
                            .symbolEffect(.variableColor)
                    }
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    VStack {
                        Image("Jprom")
                            .resizable()
                            .frame(maxHeight: 250)
                            .aspectRatio(contentMode: .fill)
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
                            
                            HStack(alignment: .firstTextBaseline, spacing: 15) {
                                NavigationLink(destination: LogView()) {
                                    Label("Logs", systemImage: "doc.text.below.ecg")
                                }
                                .buttonStyle(BorderedButtonStyle())
                                .cornerRadius(8)
                                
                                NavigationLink(destination: LogView()) {
                                    Label("Operators", systemImage: "person.badge.shield.checkmark")
                                }
                                
                                NavigationLink(destination: LogView()) {
                                    Label("Options", systemImage: "slider.horizontal.3")
                                }
                            }
                            .font(.subheadline)
                        }
                        .padding([.bottom, .leading, .trailing])
                        .padding(.top, 10)
                    }
                    .backgroundStyle(.secondary)
                    .background(
                        Image("Jprom")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 50)
                            .opacity(0.5)
                    )
                    .cornerRadius(20)
                    .scrollTransition { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0)
                            .scaleEffect(phase.isIdentity ? 1 : 0.75)
                    }
                    
                    Spacer().frame(height: 0)
                    
                    Text("Upcoming Events")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    ForEach(0..<10) { i in
                        VStack {
                            Image("Placeholder")
                                .resizable()
                                .frame(maxHeight: 250)
                                .aspectRatio(contentMode: .fill)
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
                                Text("Inactive")
                                    .font(.subheadline)
                                    .foregroundStyle(.placeholder)
                                NavigationLink(destination: LogView()) {
                                    Label("Connect to Event", systemImage: "person.wave.2")
                                        .font(.subheadline.bold())
                                        .frame(maxWidth: .infinity)
                                }
                                .cornerRadius(8)
                                .padding(.top,5)
                                .buttonStyle(BorderedProminentButtonStyle())
                            }
                            .padding([.bottom, .leading, .trailing])
                            .padding(.top, 10)
                        }
                        .backgroundStyle(.secondary)
                        .background(
                            Image("Jprom")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .blur(radius: 50)
                                .opacity(0.5)
                        )
                        .cornerRadius(20)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0)
                                .scaleEffect(phase.isIdentity ? 1 : 0.75)
                        }
                    }
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
