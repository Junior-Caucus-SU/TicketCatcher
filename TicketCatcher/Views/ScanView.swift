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
    @State private var entrantName: String? = nil
    @ObservedObject var cameraController = CameraController()
    
    var body: some View {
        ZStack {
            ColorBGView()
                .zIndex(-1)
                .opacity(0.3)
            VStack {
                //Icon and barcode status text
                BarcodeIconView(barcode: barcode, entrantName: entrantName)
                    .zIndex(1)
                Spacer()
            }
            
            VStack(alignment: .center) {
                Spacer()
                if (barcode != "Place Barcode in View to Scan" && barcode != "Invalid or Used Ticket") {
                    Spacer().frame(height: 30)
                }
                CameraView(cameraController: cameraController)
                    .frame(maxHeight: 300)
                    .background(.tertiary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.quaternary, lineWidth: 2)
                    )
                    .cornerRadius(30)
                    .shadow(color: {
                        if barcode == "Invalid or Used Ticket" {
                            return Color.red.opacity(0.6)
                        } else if barcode == "Place Barcode in View to Scan" {
                            return Color.secondary.opacity(0.6)
                        } else {
                            return Color.green.opacity(0.6)
                        }
                    }(), radius: 20, x: 0, y: 0)
                
                //Action buttons when a valid barcode is found
                ActionView(barcode: $barcode, showAdmitView: $showAdmitView, cameraController: cameraController)
                Spacer()
            }
            .animation(.smooth, value: barcode)
        }
        .padding()
        .overlay(
            Group {
                if showAdmitView {
                    AdmitView()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .shadow(color: .green.opacity(0.75), radius: 50, x: 0, y: 0)
                    //Admitted flyout
                }
            }
                .animation(.bouncy, value: showAdmitView),
            alignment: .bottom
        )
        .sensoryFeedback(.impact, trigger: cameraController.barcodeString)
        .onChange(of: cameraController.barcodeString) {
            handleBarcodeChange(newBarcode: cameraController.barcodeString)
        }
        .onAppear {
            if (barcode == "Place Barcode in View to Scan") {
                cameraController.startCamera()
            }
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
            fetchEntrantName(for: newBarcode)
        }
    }
    
    //Fetch the name of the entrant based on the code
    func fetchEntrantName(for barcode: String) {
        CKManager.shared.fetchCodename(for: barcode) { codename, error in
            if let codename = codename {
                entrantName = codename.name
            } else {
                entrantName = nil
            }
        }
    }
}

#Preview {
    ScanView()
}
