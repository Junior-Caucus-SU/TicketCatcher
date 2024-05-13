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
        Image(systemName: (barcode == "Place Barcode in View to Scan") ? "barcode.viewfinder" : "ticket")
            .contentTransition(.symbolEffect(.replace))
            .foregroundColor((barcode == "Place Barcode in View to Scan") ? .white : (barcode == "Invalid Ticket") ? .red : .green )
            .font(.title)
            .animation(.easeInOut)
    }
}
