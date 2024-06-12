//
//  EntrantView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 6/11/24.
//

import SwiftUI
import LocalAuthentication

struct EntrantView: View {
    @State private var account: String = ""
    @State private var passphrase: String = ""
    @State private var selectedEvent: EventType = .jprom
    @Binding var entered: Bool
    @Binding var attemptingToEnter: Bool
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            Form {
                VStack {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    Image("Title")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 160, height: 30)
                        .padding(.bottom)
                }
                .listRowBackground(EmptyView())
                .frame(maxWidth: .infinity, alignment: .center)
                Section {
                    TextField("Account", text: $account)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    SecureField("Passphrase", text: $passphrase)
                }
                
                Picker("Event", selection: $selectedEvent) {
                    Text("Junior Prom 2024").tag(EventType.jprom)
                    Text("Night of Dreams").tag(EventType.dreams)
                    HStack {
                        Image(systemName: "testtube.2")
                        Text("Sandbox")
                    }.tag(EventType.testing)
                }
            }.scrollDisabled(true)
            
            VStack {
                Button {
                    attemptingToEnter.toggle()
                    AuthenticationManager.shared.logIn(account: account, passphrase: passphrase) { success in
                        if success {
                            entered.toggle()
                        }
                    }
                } label: {
                    ZStack {
                        Text(attemptingToEnter ? "Logging In..." : "Log In")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                        HStack {
                            if attemptingToEnter {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(0.5)
                                    .frame(width: 20, height: 20)
                            } else {
                                Image(systemName: "key.horizontal.fill")
                            }
                            Spacer()
                        }
                    }
                }
                .disabled(!(account == Secrets.accountName && passphrase == Secrets.accountPassword))
                .cornerRadius(20)
                .buttonStyle(.borderedProminent)
                Button {
                    if let url = URL(string: "mailto:yinwei.zhang@stuysu.org") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    ZStack {
                        Text("Request Access")
                            .frame(maxWidth: .infinity, alignment: .center)
                        HStack {
                            Image(systemName: "envelope.fill")
                            Spacer()
                        }
                    }
                }
                .cornerRadius(20)
                .buttonStyle(.bordered)
                Text("You must be logged in to an iCloud account to continue.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top)
                Text("Created by Will Zhang for the Junior Caucus.")
                    .font(.footnote)
                    .bold()
                    .foregroundStyle(.secondary)
            }
            .padding()
            .controlSize(.large)
        }
        .ignoresSafeArea(.keyboard)
        .onAppear {
            AuthenticationManager.shared.authenticate { success in
                if success {
                    entered.toggle()
                }
            }
        }
    }
}

#Preview {
    EntrantView(entered: .constant(false), attemptingToEnter: .constant(false))
}
