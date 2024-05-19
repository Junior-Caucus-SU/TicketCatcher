//
//  ContentView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 10/28/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ScanView()
                .tabItem {
                    Label("Scan", systemImage: "barcode.viewfinder")
                }
            ListSheetView()
                .tabItem {
                    Label("Manage", systemImage: "person.crop.rectangle.stack")
                }
            LogSheetView()
                .tabItem {
                    Label("Event Logs", systemImage: "doc.text.below.ecg")
                }
            AddSheetView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
