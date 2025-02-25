//
//  EntrantView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 6/11/24.
//

import SwiftUI
import LocalAuthentication

struct EntrantView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var account: String = ""
    @State private var passphrase: String = ""
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
                        .frame(width: 80, height: 80)
                    Image("Title")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 25)
                }
                .listRowBackground(EmptyView())
                .frame(maxWidth: .infinity, alignment: .center)
                Section {
                    if (
                        UserDefaults.standard.bool(forKey: "hasLoggedIn") && UserDefaults.standard.bool(forKey: "canAndMustUseFaceID")
                    ) {
                        HStack {
                            Spacer()
                            Text("You may only use Face ID to log in.")
                                .font(.headline)
                                .bold()
                            Spacer()
                        }
                    } else {
                        TextField("Username", text: $account)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        SecureField("Password", text: $passphrase)
                    }
                }

            }
            .scrollDisabled(true)
            
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
                        if UserDefaults.standard.bool(forKey: "hasLoggedIn") {
                            Text("Switch Account")
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            Text("Create an Account")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                .cornerRadius(20)
                .buttonStyle(.bordered)
                Text("You must be logged in to an iCloud account to continue.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top)
                Text("Created by Will Zhang, Class of 2025")
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
