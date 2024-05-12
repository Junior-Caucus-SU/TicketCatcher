//
//  CameraWrapper.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/10/24.
//

import SwiftUI

struct CameraWrapper: View {
    let cameraController: CameraController
    @Binding var barcode: String
    
    var body: some View {
        ZStack {
            CameraView(cameraController: cameraController)
            if barcode == "Place Barcode in View to Scan" {
                ScanningLineView()
            }
        }
    }
}
