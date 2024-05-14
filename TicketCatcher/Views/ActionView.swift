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
    @Binding var showAdmitView: Bool
    var cameraController: CameraController
    
    var body: some View {
        Group {
            if barcode != "Place Barcode in View to Scan" && barcode != "Invalid Ticket" {
                Button {
                    LogManager.shared.log("Selected to mark valid admission, restarting camera session")
                    if let barcodeInt = Int(cameraController.barcodeString) {
                        cameraController.resetBarcode()
                        cameraController.restartCameraSession()
                        
                        CKManager.shared.markBarcodeAsScanned(barcode: barcodeInt) { success in
                            if success {
                                LogManager.shared.log("Barcode marked as scanned successfully")
                                DispatchQueue.main.async {
                                    self.showAdmitView = true  //admitview notification
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        self.showAdmitView = false
                                    }
                                }
                            } else {
                                LogManager.shared.log("Failed to mark barcode")
                            }
                        }
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
                    LogManager.shared.log("Ignored valid ticket, restarting camera session")
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
                        LogManager.shared.log("Scanning again after invalid scan, restarting camera session")
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
