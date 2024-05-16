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
                .foregroundColor((barcode == "Place Barcode in View to Scan") ? .white : (barcode == "Invalid or Used Ticket") ? .red : .green )
                .font(.title)
                .frame(width: 55, height: 55)
                .animation(.easeInOut, value: barcode)
            HStack {
                if (barcode != "Place Barcode in View to Scan") {
                    if (barcode != "Invalid or Used Ticket") {
                        Text("Valid Ticket").font(.system(size: 16).monospaced())
                    }
                }
                Text(barcode)
                    .font(.system(size: 16).monospaced())
                    .bold()
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    BarcodeIconView(barcode: "Example Text")
}
