//
//  DistributeView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/21/24.
//

import SwiftUI

struct DistributeView: View {
    @State private var bgColor = Color(.sRGB, red: 0, green: 0, blue: 0)
    @State private var fgColor = Color(.sRGB, red: 1, green: 1, blue: 1)
    @State private var bcColor = Color(.sRGB, red: 1, green: 1, blue: 1)
    @State private var barcodeNumberDisplay = "Session ID (Unsecure)"
    @State private var schemaUsage = "Schema"
    @State private var textContent = ""
    @State private var isSending = false
    @State private var progress: CGFloat = 0.0
    @State private var sentCount = 0
    @State private var totalEmails = 0
    @State private var insigniaImageAssetLink = ""
    @State private var limit = ""
    private let barcodeNumberOptions = ["Session ID (Unsecure)", "OSIS", "Name", "None"]
    private let schemaOptions = ["Schema", "OSIS", "Name", "None"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Label("Look & Feel", systemImage: "paintpalette")) {
                    TextField("Insignia Image Asset Link", text: $insigniaImageAssetLink)
                    ColorPicker("Background Color", selection: $bgColor)
                    ColorPicker("Foreground Color", selection: $fgColor)
                    ColorPicker("Barcode Color", selection: $bcColor)
                    Picker("Barcode Text", selection: $barcodeNumberDisplay) {
                        ForEach(barcodeNumberOptions, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Section(header: Label("Message Content", systemImage: "character.cursor.ibeam")) {
                    TextEditor(text: $textContent)
                        .frame(height: 100)
                }
                Section(header: Label("Recipients", systemImage: "person.crop.circle")) {
                    Picker("Schema", selection: $schemaUsage) {
                        ForEach(schemaOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Send Count Limit", text: $limit)
                        .keyboardType(.numberPad)
                }
                Section {
                    Button(action: {
                        let limitInt = Int(limit) ?? 0
                        totalEmails = limitInt
                        isSending = true
                        sendEmails(bgColor: bgColor, fgColor: fgColor, imgAssetLink: insigniaImageAssetLink, title: barcodeNumberDisplay, limit: limitInt, paragraph: textContent, updateProgress: updateProgress)
                    }) {
                        Label("Send E-Mails Now", systemImage: "paperplane.fill")
                    }.bold()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Image("SendIt")
                        .scaleEffect(0.06)
                }
            }
            .overlay {
                if isSending {
                    Rectangle()
                        .fill(.thinMaterial)
                        .overlay(
                            VStack {
                                Image(systemName: "paperplane.fill")
                                    .symbolEffect(.pulse)
                                    .imageScale(.large)
                                    .padding()
                                Text("Sending Ticket E-Mails")
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                    .padding(.bottom, 20)
                                
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .foregroundStyle(.tertiary)
                                    Rectangle()
                                        .scaleEffect(x: progress, anchor: .leading)
                                        .animation(.smooth, value: progress)
                                        .foregroundStyle(.blue)
                                }
                                .frame(height: 3)
                                .cornerRadius(5)
                                .padding(.horizontal, 75)
                                
                                Text("\(sentCount) of \(totalEmails) Sent")
                                    .font(.subheadline)
                                    .transaction { t in
                                        t.animation = .default
                                    }
                                    .contentTransition(.numericText())
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                                    .padding(.top, 5)
                                
                            }
                        )
                        .ignoresSafeArea()
                }
            }
        }
    }
    
    func updateProgress(sentCount: Int) {
        self.sentCount = sentCount
        self.progress = CGFloat(sentCount) / CGFloat(totalEmails)
        if sentCount == totalEmails {
            isSending = false
        }
    }
}

#Preview {
    DistributeView()
}
