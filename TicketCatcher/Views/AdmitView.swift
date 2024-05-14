//
//  AdmitView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/13/24.
//

import SwiftUI
import UIKit

struct AdmitView: View {
    var body: some View {
        HStack {
            Image(systemName: "person.fill.checkmark")
                .imageScale(.large)
                .padding()
            Text("Attendee Admitted")
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(Color.green)
        .foregroundColor(.white)
        .cornerRadius(20)
        .padding(25)
        .padding(.bottom, 20.0)
    }
}

#Preview {
    AdmitView()
}
