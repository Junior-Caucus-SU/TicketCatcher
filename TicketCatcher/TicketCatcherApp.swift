//
//  TicketCatcherApp.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 10/28/23.
//

import SwiftUI

///Main log in screne. Maybe consider moving login logic here.
@main
struct TicketCatcherApp: App {
    @State private var entered = false
    var body: some Scene {
        WindowGroup {
            ZStack {
                if !entered {
                    EntrantView(entered: $entered)
                        .transition(.opacity)
                } else {
                    ContentView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: entered)
        }
    }
}

///Login view.
struct EntrantView: View {
    @Binding var entered: Bool
    var body: some View {
        VStack {
            Spacer()
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 50, height: 50)))
            Image("Title")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 50)
            Spacer()
            VStack {
                Button {
                    entered.toggle()
                } label: {
                    Text("Junior Prom 2024")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .cornerRadius(20)
                Button {
                    entered.toggle()
                } label: {
                    Text("Other Events Coming Soon")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .disabled(true)
                .cornerRadius(20)
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .controlSize(.large)
        }
    }
}

#Preview {
    EntrantView(entered: .constant(false))
}
