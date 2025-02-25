//
//  SendMethodSheet.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 2/24/25.
//

import SwiftUI

struct SendMethodSheet: View {
    @AppStorage("key") private var key = ""

    var body: some View {
            Form {
                Section {
                        HStack(alignment: .center) {
                            Spacer()
                            VStack(alignment: .center) {
                                Image(systemName: "mail")
                                    .font(.largeTitle)
                                    .symbolRenderingMode(.multicolor)
                                    .padding(.bottom, 5)
                                Text("SendGrid API Key")
                                    .font(.title2).bold()
                                    .padding(.bottom, 3)
                                Text("Add your own SendGrid API Key.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Link("Learn more...", destination: URL(string: "https://www.twilio.com/docs/sendgrid/ui/account-and-settings/api-keys")!)
                                    .font(.subheadline)
                            }
                            .padding()
                            Spacer()
                        }
                    }
                TextField("Enter Key Here", text: $key)
                
                Section {Button("Save"){}}
            }
            .navigationTitle("Distribution Service")
    }
}

#Preview {
    SendMethodSheet()
}
