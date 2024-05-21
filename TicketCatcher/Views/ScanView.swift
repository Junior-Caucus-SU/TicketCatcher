//
//  ScanView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/19/24.
//

import SwiftUI

struct ScanView: View {
    @State private var showAdmitView = false
    @State private var barcode: String = "Place Barcode in View to Scan"
    @ObservedObject var cameraController = CameraController()
    
    var body: some View {
        VStack {
            //Icon and barcode status text
            BarcodeIconView(barcode: barcode)
            Spacer()
            VStack(alignment: .center) {
                CameraView(cameraController: cameraController)
                    .frame(maxHeight: 300)
                    .cornerRadius(30)
                    .shadow(color: {
                        if barcode == "Invalid or Used Ticket" {
                            return Color.red.opacity(0.6)
                        } else if barcode == "Place Barcode in View to Scan" {
                            return Color.clear
                        } else {
                            return Color.green.opacity(0.6)
                        }
                    }(), radius: 20, x: 0, y: 0)
                    .zIndex(1)
                //Action buttons when a valid barcode is found
                ActionView(barcode: $barcode, showAdmitView: $showAdmitView, cameraController: cameraController)
                    .zIndex(2) //Should be above the shadow
            }
            .animation(.easeInOut(duration: 0.5), value: barcode)
            Spacer()
        }
        .padding(25)
        .overlay(
            Group {
                if showAdmitView {
                    AdmitView()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .shadow(color: .green.opacity(0.75), radius: 50, x: 0, y: 0)
                    //Admitted flyout
                }
            }
                .animation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5), value: showAdmitView),
            alignment: .bottom
        )
        .sensoryFeedback(.impact, trigger: cameraController.barcodeString)
        .onChange(of: cameraController.barcodeString) {
            handleBarcodeChange(newBarcode: cameraController.barcodeString)
        }
        .onAppear {
            cameraController.startCamera()
        }
        .onDisappear {
            cameraController.stopCamera()
        }
    }
    
    ///If the barcode is not idle, then stop the camera
    func handleBarcodeChange(newBarcode: String) {
        barcode = newBarcode
        if newBarcode != "Place Barcode in View to Scan" {
            cameraController.stopCamera()
        }
    }
}

#Preview {
    ScanView()
}
