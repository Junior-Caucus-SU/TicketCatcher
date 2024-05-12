//  AddSheetView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 2/11/24.
//

import SwiftUI

struct AddSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var account: String = ""
    @State private var passphrase: String = ""
    @State private var atname: String = ""
    @State private var osis: String = ""
    
    let correctPassword = Secrets.adminPassword
    let correctName = Secrets.adminName
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0){
                VStack (alignment: .leading){
                    Text("Manually add an attendee and create a barcode for that person. This should only be used for administration purposes.")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom)
                    
                    Text("Need help? Call 929-519-5260")
                        .font(.caption)
                        .bold()
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.leading)
                }.padding([.top, .leading, .trailing])
                
                Form {
                    Section{
                        TextField("Account", text: $account)
                        SecureField("Passphrase", text: $passphrase)
                    }
                    
                    Section{
                        TextField("Attendee Name", text: $atname)
                        SecureField("OSIS", text: $osis)
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                
                Button {
                    CKManager.shared.addCodenameRecord(name: atname, barcode: Int(osis)!) { error in
                        if let error = error {
                            print("no record added")
                        }
                    }
                }
            label: {
                HStack {
                    Text("Add Attendee")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "cloud")
                }
            }
            .buttonStyle(.borderedProminent)
            .cornerRadius(20)
            .padding()
            .controlSize(.large)
            .disabled(!(account == correctName && passphrase == correctPassword))
            }
            .navigationTitle("Add Attendee")
        }
    }
}

#Preview {
    AddSheetView()
}
