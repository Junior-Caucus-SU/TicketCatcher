//
//  BarcodeIconView.swift
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
                .foregroundColor((barcode == "Place Barcode in View to Scan") ? .primary : (barcode == "Invalid or Used Ticket") ? .red : .green )
                .font(.title)
                .frame(width: 55, height: 55)
                .animation(.snappy, value: barcode)
            Text(
                barcode == "Place Barcode in View to Scan"
                ? barcode
                : barcode == "Invalid or Used Ticket"
                ? "Invalid or Used Ticket"
                : "Valid Ticket: \(barcode)"
            )
            .font(.system(size: 16).monospaced())
            .bold()
            .foregroundColor(barcode == "Place Barcode in View to Scan" ? .secondary : (barcode == "Invalid or Used Ticket") ? .red : .green)
            .transition(.asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .top).combined(with: .opacity)
            ))
            .id(barcode)
        }
        .animation(.snappy, value: barcode)
    }
}

#Preview {
    BarcodeIconView(barcode: "Place Barcode in View to Scan")
}
