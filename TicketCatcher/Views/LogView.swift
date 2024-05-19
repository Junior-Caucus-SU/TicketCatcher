//
//  LogSheetView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/12/24.
//

import SwiftUI

class LogManager: ObservableObject {
    static let shared = LogManager()
    @Published var logs: [String] = []
    
    private init() {}
    
    func log(_ message: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = dateFormatter.string(from: Date())
        let fullMessage = "\(timestamp)~\(message)"
        
        DispatchQueue.main.async {
            if let lastLog = self.logs.last, lastLog == fullMessage {
                return
            }
            self.logs.append(fullMessage)
        }
    }
}

struct LogView: View {
    @ObservedObject var logManager = LogManager.shared
    let textColor = Color.primary
    let timestampColor = Color.secondary
    let messageFont = Font
        .system(size: 14)
        .monospaced()
    let timestampFont = Font
        .system(size: 10)
        .monospaced()
        .bold()
    
    var body: some View {
        NavigationStack {
            List(logManager.logs, id: \.self) { log in
                if let colonIndex = log.firstIndex(of: "~") {
                    let timestamp = log[..<colonIndex]
                    let message = log[log.index(after: colonIndex)...]
                    VStack (alignment: .leading) {
                        Text(String(timestamp))
                            .font(timestampFont)
                            .foregroundColor(timestampColor)
                        Text(String(message))
                            .font(messageFont)
                            .foregroundColor(textColor)
                    }
                } else {
                    Text(log)
                        .font(messageFont)
                        .foregroundColor(textColor)
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Logs")
        }
    }
}

#Preview {
    LogView()
}
