//
//  ContentView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 10/28/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showAdmitView = false
    @State private var showList = false
    @State private var showImportSheet = false
    @State private var showAddSheet = false
    @State private var showLog = false
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
            navigationButtons //Bottom buttons
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
    }
    
    ///Bottom buttons
    private var navigationButtons: some View {
        HStack {
            Button {
                showAddSheet.toggle()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .frame(maxWidth: .infinity, maxHeight: 30)
            }
            .buttonStyle(.borderedProminent)
            .cornerRadius(20)
            .sheet(isPresented: $showAddSheet) {
                AddSheetView()
                    .presentationBackground(.thickMaterial)
            }
            .controlSize(.large)
            //Add attendee
            
            Button {
                showList.toggle()
            } label: {
                Image(systemName: "person.3.fill")
                    .frame(maxWidth: .infinity, maxHeight: 30)
            }
            .buttonStyle(.bordered)
            .cornerRadius(20)
            .sheet(isPresented: $showList) {
                ListSheetView()
                    .presentationBackground(.thickMaterial)
            }
            .controlSize(.large)
            //Attendee List
            
            Button {
                showImportSheet.toggle()
            } label: {
                Image(systemName: "arrow.up.doc.fill")
                    .frame(maxWidth: .infinity, maxHeight: 30)
            }
            .buttonStyle(.bordered)
            .cornerRadius(20)
            .sheet(isPresented: $showImportSheet) {
                UploadSheetView()
                    .presentationBackground(.thickMaterial)
            }
            .controlSize(.large)
            //Upload Attendee List
            
            Button {
                showLog.toggle()
            } label: {
                Image(systemName: "doc.text.below.ecg.fill")
                    .frame(maxWidth: .infinity, maxHeight: 30)
            }
            .buttonStyle(.bordered)
            .cornerRadius(20)
            .sheet(isPresented: $showLog) {
                LogSheetView()
                    .presentationBackground(.thickMaterial)
            }
            .controlSize(.large)
            //Logs
        }
        .padding(.top, 35)
        .padding(.bottom, 20)
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
    ContentView()
}
