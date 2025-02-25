//
//  ContentView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 10/28/23.
//

import SwiftUI
import ActivityKit

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
            DistributeView()
                .tabItem {
                    Label("SendIt", systemImage: "paperplane")
                }
            ControlsView()
                .tabItem {
                    Label("Controls", systemImage: "slider.horizontal.3")
                }
            UserView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
