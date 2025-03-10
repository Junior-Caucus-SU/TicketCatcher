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
            Spacer()
                .frame(height: 15)
            if barcode != "Place Barcode in View to Scan" && barcode != "Invalid or Used Ticket" {
                //Mark as admitted
                Button {
                    LogManager.shared.log("Selected to mark valid admission, restarting camera session")
                    cameraController.resetBarcode()
                    cameraController.restartCameraSession()
                    
                    CKManager.shared.markBarcodeAsScanned(barcode: barcode) { success, err in
                        if success {
                            LogManager.shared.log("Barcode marked as scanned successfully")
                            DispatchQueue.main.async {
                                self.showAdmitView = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    self.showAdmitView = false
                                }
                            }
                        } else {
                            LogManager.shared.log("Failed to mark barcode with reason \(err ?? "unknown")")
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
                
                //Ignored a valid ticket
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
                if barcode == "Invalid or Used Ticket" {
                    
                    //The scanned ticket is invalid, we can start another camera session
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
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

#Preview {
    ActionView(
        barcode: .constant("123"),
        showAdmitView: .constant(false),
        cameraController: CameraController()
    )
}
