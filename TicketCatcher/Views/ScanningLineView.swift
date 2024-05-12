//
//  ScanningLineView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 10/29/23.
//

import SwiftUI

struct ScanningLineView: View {
    @State private var yOffset: CGFloat = -0.02
    
    var body: some View {
        GeometryReader { geometry in
            Color.white.opacity(0.5)
                .frame(width: geometry.size.width, height: 1)
                .offset(y: yOffset * geometry.size.height)
                .animation(
                    Animation.easeInOut(duration: 2)
                        .repeatForever(autoreverses: true)
                )
                .onAppear() {
                    yOffset = 1.02
                }
        }
    }
}

struct ScanningLineView_Previews: PreviewProvider {
    static var previews: some View {
        ScanningLineView()
            .frame(height: 300)
            .background(Color.gray)
    }
}
