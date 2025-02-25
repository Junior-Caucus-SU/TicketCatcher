//
//  BarcodeIconView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 11/11/23.
//

import SwiftUI

struct BarcodeIconView: View {
    var barcode: String
    var entrantName: String?

    var body: some View {
        VStack {
            Image(systemName: (barcode == "Place Barcode in View to Scan") ? "barcode.viewfinder" : "ticket")
                .contentTransition(.symbolEffect(.replace))
                .foregroundColor((barcode == "Place Barcode in View to Scan") ? .secondary : (barcode == "Invalid or Used Ticket") ? .red : .green )
                .font(.title)
                .frame(width: 50, height: 50)
                .animation(.snappy, value: barcode)
            Text(
                barcode == "Place Barcode in View to Scan"
                ? barcode
                : barcode == "Invalid or Used Ticket"
                ? "Invalid or Used Ticket"
                : barcode
            )
            .font(.system(size: 16).monospaced())
            .bold()
            .foregroundColor(barcode == "Place Barcode in View to Scan" ? .secondary : (barcode == "Invalid or Used Ticket") ? .red : .green)
            .transition(.blurReplace)
            .id(barcode)
            
            if let name = entrantName, barcode != "Place Barcode in View to Scan" && barcode != "Invalid or Used Ticket" {
                Text("Valid for \(name)")
                    .font(.system(size: 14).monospaced())
                    .bold()
                    .foregroundColor(.green)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.green.opacity(0.2)))
                    .transition(.blurReplace())
            }
        }
        .animation(.snappy, value: barcode)
    }
}

#Preview {
    BarcodeIconView(barcode: "Place Barcode in View to Scan", entrantName: "Bibba")
}
