//  ImportSheetView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 2/11/24.
//

import SwiftUI

enum Schema: String, CaseIterable, Identifiable {
    case jprom, general, testing
    var id: Self { self }
}

struct ImportSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var uploadManager = UploadManager()
    @State private var account: String = ""
    @State private var passphrase: String = ""
    @State private var pickingFile = false
    @State private var csvURL: URL?
    @State private var selectedSchema: Schema = .jprom
    
    let correctPassword = Secrets.accountPassword
    let correctName = Secrets.accountName
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0){
                VStack (alignment: .leading){
                    Text("Upload an attendee CSV file with the correct identifications and formatting provided by Polazzo. Files with incorrect formatting will not be accepted. CloudKit will be updated in a few minutes post-upload. All existing IDs will not have their statuses changed.")
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
                    Section {
                        Button {
                            pickingFile = true
                        } label: {
                            HStack {
                                if let csvURL = csvURL {
                                    Text(csvURL.lastPathComponent)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } else {
                                    Text("Add CSV File")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                Image(systemName: "plus")
                            }
                        }
                        List {
                            Picker("Schema", selection: $selectedSchema) {
                                Text("Junior Prom 2024 Receipt").tag(Schema.jprom)
                                Text("General").tag(Schema.general)
                                Text("Internal Testing").tag(Schema.testing)
                            }
                        }
                    }
                    .fileImporter(
                        isPresented: $pickingFile,
                        allowedContentTypes: [.commaSeparatedText],
                        allowsMultipleSelection: false
                    ) { result in
                        switch result {
                        case .success(let urls):
                            guard let url = urls.first else { return }
                            if url.startAccessingSecurityScopedResource() {
                                csvURL = url
                            } else {
                                LogManager.shared.log("Cannot access CSV")
                            }
                        case .failure(let error):
                            LogManager.shared.log("File selection error on \(error.localizedDescription)")
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                
                Button {
                    if (!uploadManager.isUploading) {
                        if let csvURL = csvURL {
                            uploadManager.uploadData(url: csvURL) {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(uploadManager.isUploading ? "Uploading \(Int(uploadManager.progress * 100))%" : "Upload List to CloudKit")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if (uploadManager.isUploading) {
                            Image(systemName: "rays")
                                .symbolEffect(.variableColor.cumulative.hideInactiveLayers.nonReversing)
                        } else {
                            Image(systemName: "cloud")
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .cornerRadius(20)
                .padding()
                .controlSize(.large)
                .disabled(!(account == correctName && passphrase == correctPassword))
            }
            .navigationTitle("Upload List")
            .onDisappear {
                if let csvURL = csvURL {
                    csvURL.stopAccessingSecurityScopedResource()
                }
            }
        }
    }
}

#Preview {
    ImportSheetView()
}
