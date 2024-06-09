//
//  SchemaTotalView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 6/6/24.
//

import SwiftUI

struct SchemaTotalView: View {
    @State private var schemas: [String: [String: String]] = [:]

    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(schemas.keys), id: \.self) { schemaName in
                    if let schema = schemas[schemaName] {
                        Section(header: Text(schemaName)) {
                            ForEach(schema.keys.sorted(), id: \.self) { key in
                                HStack {
                                    Text(key)
                                    Spacer()
                                }
                                .badge("Column \(schema[key] ?? "Ignored")")
                            }
                        }
                    }
                }
                NavigationLink(destination: SchemaEditorView()) {
                    Text("Add New Schema")
                }
            }
            .navigationTitle("Local Schemas")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: clearAllSchemas) {
                        Text("Clear All")
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear(perform: loadSchemas)
        }
    }

    private func loadSchemas() {
        schemas = UserDefaults.standard.dictionary(forKey: "schemas") as? [String: [String: String]] ?? [:]
    }

    private func clearAllSchemas() {
        schemas.removeAll()
        UserDefaults.standard.setValue(schemas, forKey: "schemas")
    }
}

#Preview {
    SchemaTotalView()
}
