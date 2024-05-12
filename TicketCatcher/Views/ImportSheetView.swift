//  ImportSheetView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 2/11/24.
//

import SwiftUI

struct ImportSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var uploadManager = UploadManager()
    @State private var account: String = ""
    @State private var passphrase: String = ""
    @State private var pickingFile = false
    @State private var csvURL: URL?
    
    let correctPassword = Secrets.accountPassword
    let correctName = Secrets.accountName
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0){
                VStack (alignment: .leading){
                    Text("Upload a CSV file with the correct format provided by Polazzo. Files with incorrect formatting will not be accepted. CloudKit will be updated in a few minutes post-upload. All existing IDs will not have their statuses changed.")
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
                                print("Cannot access")
                            }
                        case .failure(let error):
                            uploadManager.errorMessage = "File selection error: \(error.localizedDescription)"
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                
                    Button {
                        if let csvURL = csvURL {
                            uploadManager.uploadData(url: csvURL) {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } label: {
                        HStack {
                            Text(uploadManager.isUploading ? "Uploading \(Int(uploadManager.progress * 100))%" : "Import File to CloudKit")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if (uploadManager.isUploading) {
                                Image(systemName: "rays")
                                    .symbolEffect(.variableColor.cumulative.dimInactiveLayers.nonReversing)
                            } else {
                                Image(systemName: "cloud")
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(20)
                    .padding()
                    .controlSize(.large)
                    .disabled(uploadManager.isUploading || !(account == correctName && passphrase == correctPassword))
            }
            .alert("Upload Error", isPresented: Binding<Bool>(
                get: { uploadManager.errorMessage != nil },
                set: { _ in uploadManager.errorMessage = nil }
            ), presenting: uploadManager.errorMessage) { error in
                Button("Quit App") {
                    exit(0)
                }
            } message: { error in
                Text(error)
            }
            .navigationTitle("Upload CSV File")
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
