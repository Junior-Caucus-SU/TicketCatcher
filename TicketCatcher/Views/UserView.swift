//
//  EventView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 6/6/24.
//

import SwiftUI

struct UserView: View {
    @AppStorage("canAndMustUseFaceID") private var canAndMustUseFaceID = true

    var body: some View {
        NavigationStack {
            ScrollView {
                
                VStack(alignment: .leading) {
                    Toggle("Enable & Require Biometric Login", isOn: $canAndMustUseFaceID)
                        .bold()
                    Text("When this is enabled, you will only be able to log in with Face ID or Touch ID after the initial log in. It is recommended that this be enabled, as it provides an extra layer of security against unauthorized access.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 5)
                }
                .padding()
                .background(.quinary)
                .cornerRadius(20)
                .padding()
                
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
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                    }
                    .backgroundStyle(.secondary)
                    .background(
                        Image("Jprom")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 50)
                            .opacity(0.3)
                    )
                    .cornerRadius(20)
                    .scrollTransition { content, phase in
                        content
                            .blur(radius: phase.isIdentity ? 0 : 20)
                            .opacity(phase.isIdentity ? 1 : 0.3)
                    }
                    
                    Spacer().frame(height: 0)
                    
                    Text("My Events")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    ForEach(0..<3) { i in
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
                                    Label("Forfeit Current Event & Connect", systemImage: "person.wave.2")
                                        .font(.subheadline.bold())
                                        .frame(maxWidth: .infinity)
                                }
                                .cornerRadius(10)
                                .padding(.top,5)
                                .buttonStyle(BorderedButtonStyle())
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
                                .opacity(0.3)
                        )
                        .cornerRadius(20)
                        .scrollTransition { content, phase in
                            content
                                .blur(radius: phase.isIdentity ? 0 : 20)
                                .opacity(phase.isIdentity ? 1 : 0.3)
                        }
                    }
                    Spacer().frame(height: 0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {}) {
                            Text("Register Event")
                        }
                    }
                }
                .padding()
                Spacer()
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    UserView()
}
