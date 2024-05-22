//
//  TicketCatcherApp.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 10/28/23.
//

import SwiftUI
import LocalAuthentication

enum EventType: String, CaseIterable, Identifiable {
    case jprom, testing, dreams
    var id: Self {self}
}

///Main log in screne. Maybe consider moving login logic here.
@main
struct TicketCatcherApp: App {
    @State private var entered = false
    
    init() {
        UserDefaults.standard.register(defaults: ["canUseFaceID": true])
    }
    var body: some Scene {
        WindowGroup {
            ZStack {
                if !entered {
                    EntrantView(entered: $entered)
                        .transition(.opacity)
                } else {
                    ContentView()
                        .transition(.opacity)
                }
            }
            .animation(.smooth, value: entered)
        }
    }
}

///Login view.
struct EntrantView: View {
    @State private var account: String = ""
    @State private var passphrase: String = ""
    @State private var selectedEvent: EventType = .jprom
    @Binding var entered: Bool
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            Spacer()
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 50, height: 50)))
            Image("Title")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 160, height: 30)
                .padding(.bottom)
            
            Form {
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
                    logIn()
                } label: {
                    ZStack {
                        Text("Log In")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                        HStack {
                            Image(systemName: "key.horizontal.fill")
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
        .onAppear(perform: authenticate)
    }
    
    func logIn() {
        if account == Secrets.accountName && passphrase == Secrets.accountPassword {
            UserDefaults.standard.set(true, forKey: "hasLoggedIn")
            entered.toggle()
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Quickly log in to TicketCatcher."
            
            if UserDefaults.standard.bool(forKey: "hasLoggedIn") && UserDefaults.standard.bool(forKey: "canUseFaceID") {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        entered.toggle()
                    }
                }
            }
        }
    }
}

#Preview {
    EntrantView(entered: .constant(false))
}
