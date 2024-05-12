//
//  ActionView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 1/13/24.
//

import SwiftUI
import CloudKit

struct ActionView: View {
    @Binding var barcode: String
    var cameraController: CameraController
    
    var body: some View {
        Group {
            if barcode != "Place Barcode in View to Scan" && barcode != "Invalid Ticket" {
                Button {
                    if let barcodeInt = Int(cameraController.barcodeString) {
                        cameraController.resetBarcode()
                        cameraController.restartCameraSession()

                        CKManager.shared.markBarcodeAsScanned(barcode: barcodeInt) { success in
                            if success {
                                print("barcode marked as scanned successfully.")
                            } else {
                                print("failed to mark barcode")
                            }
                        }
                        
                        print("clicked admit, restarting cam session")
                    }
                } label: {
                    HStack {
                        Text("Admit Now")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "person")
                    }
                }
                .buttonStyle(.borderedProminent)
                .cornerRadius(20)
                .controlSize(.large)
                
                Button {
                    cameraController.resetBarcode()
                    cameraController.restartCameraSession()
                    print("clicked Ignore, restarting cam sesh")
                } label: {
                    HStack {
                        Text("Ignore")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "minus")
                    }
                }
                .buttonStyle(.bordered)
                .cornerRadius(20)
                .controlSize(.large)
            } else {
                if barcode == "Invalid Ticket" {
                    Button {
                        cameraController.resetBarcode()
                        cameraController.restartCameraSession()
                        print("clicked scan again, restarting cam sesh")
                    } label: {
                        HStack {
                            Text("Scan Again")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "arrow.circlepath")
                        }
                    }
                    .buttonStyle(.bordered)
                    .cornerRadius(20)
                    .controlSize(.large)
                }
                EmptyView()
            }
        }
    }
}
