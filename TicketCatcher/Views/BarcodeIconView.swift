//
//  BarcodeImageView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 11/11/23.
//

import SwiftUI

struct BarcodeIconView: View {
    var barcode: String
    
    var body: some View {
        VStack {
            Image(systemName: (barcode == "Place Barcode in View to Scan") ? "barcode.viewfinder" : "ticket")
                .contentTransition(.symbolEffect(.replace))
                .foregroundColor((barcode == "Place Barcode in View to Scan") ? .white : (barcode == "Invalid Ticket") ? .red : .green )
                .font(.title)
                .frame(width: 55, height: 55)
                .animation(.easeInOut)
            Text(barcode)
                .font(.system(size: 16).monospaced())
                .bold()
                .animation(.easeInOut)
        }
    }
}

#Preview {
    BarcodeIconView(barcode: "Example Text")
}
