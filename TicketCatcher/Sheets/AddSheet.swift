//  AddSheetView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 2/11/24.
//

import SwiftUI

struct AddSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var atname: String = ""
    @State private var osis: String = ""
    @State private var sessionID: String = ""
    
    @State private var showAlert = false
    @State private var Message = ""
    @State private var Title = ""
    @State private var showBarcodeSheet = false
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Attendee Name", text: $atname)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                TextField("OSIS", text: $osis)
                    .keyboardType(.numberPad)
                SecureField("Session ID", text: $sessionID)
                
                Section {
                    Text("Manually add an attendee and create a barcode for that entry. For security reasons, the barcode may not be viewed again.")
                        .font(.caption)
                        .foregroundColor(Color.secondary)
                }
                .listRowBackground(EmptyView())
                .listSectionSpacing(10)
                
            }
            .scrollContentBackground(.hidden)
            
            Button {
                CKManager.shared.addCodenameRecord(name: atname, osis: Int(osis)!, validity: "Approved", barcode: sessionID) { error in
                    if error != nil {
                        LogManager.shared.log("No record added due to an error")
                        Message = "Failed to add attendee due to an error."
                        Title = "Failed to Add Attendee"
                        showAlert = true
                    } else {
                        LogManager.shared.log("Added attendee record manually for \(osis)")
                        Message = "Added attendee successfully. Be sure to save the barcode now as it cannot be viewed again."
                        Title = "Added Attendee"
                        showAlert = true
                    }
                }
            }
        label: {
            HStack {
                Text("Add Attendee")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "person.badge.plus")
            }
        }
        .buttonStyle(.borderedProminent)
        .cornerRadius(20)
        .padding()
        .controlSize(.large)
        .navigationTitle("Add Attendee")
        .alert(isPresented: $showAlert) {
            Alert(title: Text(Title),
                  message: Text(Message),
                  primaryButton: .default(Text("Generate Barcode"), action: {
                showBarcodeSheet = true
            }), secondaryButton: .destructive(Text("Dismiss")))
        }
        .sheet(isPresented: $showBarcodeSheet) {
            BarcodeSheet(barcodeValue: sessionID)
        }
        }
    }
}

#Preview {
    AddSheet()
}
