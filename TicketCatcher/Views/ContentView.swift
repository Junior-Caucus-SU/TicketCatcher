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
            ListView()
                .tabItem {
                    Label("Manage", systemImage: "person.crop.rectangle.stack")
                }
            LogView()
                .tabItem {
                    Label("Event Logs", systemImage: "doc.text.below.ecg")
                }
            EmptyView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
