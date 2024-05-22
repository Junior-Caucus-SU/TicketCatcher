//
//  DistributeView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/21/24.
//

import SwiftUI

struct DistributeView: View {
    var body: some View {
        VStack {
            Image("SendIt")
                .scaleEffect(CGSize(width: 0.2, height: 0.2))
            Text("Coming Sooner or Later...")
                .font(.headline)
            Text("Mail tickets in batch, integrate with Apple Wallet, and do so much more with SendIt!")
                .padding()
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}

#Preview {
    DistributeView()
}
