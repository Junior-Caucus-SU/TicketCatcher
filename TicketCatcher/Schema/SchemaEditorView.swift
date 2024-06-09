//
//  SchemaEditorView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 6/6/24.
//

import SwiftUI

struct SchemaEditorView: View {
    @State private var sessionIDColumn = ""
    @State private var osisColumn = ""
    @State private var validityColumn = ""
    @State private var nameColumn = ""
    @State private var schemaName = ""
    @State private var emailColumn = ""
    @State private var isShowingSaveAlert = false
    @State private var isShowingAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    RectangleView(title: "Session ID", description: "The Session ID is used for identifying the barcode validity, which is also the barcode imprinted on the ticket.", columnText: $sessionIDColumn)
                        .padding()
                    Divider()
                    RectangleView(title: "OSIS", description: "The OSIS is the NYCDOE nine-digit number that is issued to all students who attend a New York City public school. The OSIS is an optionally collected field used for identification purposes.", columnText: $osisColumn)
                        .padding()
                    Divider()
                    RectangleView(title: "Validity", description: "The Validity must be set to Approved for the ticket to be considered valid.", columnText: $validityColumn)
                        .padding()
                    Divider()
                    RectangleView(title: "Name", description: "The Name must be the first and last name of the attendee.", columnText: $nameColumn)
                        .padding()
                    Divider()
                    RectangleView(title: "E-Mail", description: "The e-mail address of the attendee. This is used for SendIt services.", columnText: $emailColumn)
                        .padding()
                }
                .padding()
            }
            .navigationBarTitle("Schema Editor")
            .navigationBarItems(trailing: Button(action: {
                isShowingSaveAlert = true
            }) {
                Text("Save")
            })
            .alert("Save Schema", isPresented: $isShowingSaveAlert) {
                TextField("Schema Name", text: $schemaName)
                Button("Save", action: saveSchema)
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Enter the schema name to save the schema for future use. It will be available on this device only.")
            }
        }
    }

    private func saveSchema() {
        guard !schemaName.isEmpty else { return }

        let schema = [
            "SessionID": sessionIDColumn,
            "OSIS": osisColumn,
            "Validity": validityColumn,
            "Name": nameColumn,
            "Email": emailColumn
        ]

        var schemas = UserDefaults.standard.dictionary(forKey: "schemas") as? [String: [String: String]] ?? [:]
        schemas[schemaName] = schema
        UserDefaults.standard.set(schemas, forKey: "schemas")

        schemaName = ""
    }
}

struct RectangleView: View {
    let title: String
    let description: String
    @Binding var columnText: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
            }
            Spacer()
                .frame(height: 20)
            Text(description)
                .foregroundColor(.secondary)
            Spacer()
                .frame(height: 25)
            TextField("Column Number", text: $columnText)
                .textFieldStyle(.plain)
        }
    }
}

#Preview {
    SchemaEditorView()
}
