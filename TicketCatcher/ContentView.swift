//
//  ContentView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 10/28/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showList = false
    @State private var showImportSheet = false
    @State private var showAddSheet = false
    @State private var showLog = false
    @State private var barcode: String = "Place Barcode in View to Scan"
    @ObservedObject var cameraController = CameraController()
    
    var body: some View {
        VStack {
            BarcodeIconView(barcode: barcode)
            Spacer()
            VStack(alignment: .center) {
                CameraWrapper(cameraController: cameraController, barcode: $barcode)
                    .frame(maxHeight: 300)
                    .cornerRadius(25)
                ActionView(barcode: $barcode, cameraController: cameraController)
            }
            .animation(.easeInOut(duration: 0.5), value: barcode)
            Spacer()
            navigationButtons
        }
        .padding(25)
        .preferredColorScheme(.dark)
        .onChange(of: cameraController.barcodeString) { newBarcode in
            handleBarcodeChange(newBarcode: newBarcode) //fix deprecation soon!!!
        }
    }
    
    private var navigationButtons: some View {
        HStack {
            Button {
                showAddSheet.toggle()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .frame(maxWidth: 30, maxHeight: 30)
            }
            .buttonStyle(.borderedProminent)
            .cornerRadius(20)
            .sheet(isPresented: $showAddSheet) {
                AddSheetView()
                    .presentationBackground(.thickMaterial)
            }
            .controlSize(.large)
            
            Button {
                showList.toggle()
            } label: {
                Image(systemName: "person.3.fill")
                    .frame(maxWidth: 30, maxHeight: 30)
            }
            .buttonStyle(.bordered)
            .cornerRadius(20)
            .sheet(isPresented: $showList) {
                ListSheetView()
                    .presentationBackground(.thickMaterial)
            }
            .controlSize(.large)
            
            Button {
                showImportSheet.toggle()
            } label: {
                Image(systemName: "arrow.up.doc.fill")
                    .frame(maxWidth: 30, maxHeight: 30)
            }
            .buttonStyle(.bordered)
            .cornerRadius(20)
            .sheet(isPresented: $showImportSheet) {
                ImportSheetView()
                    .presentationBackground(.thickMaterial)
            }
            .controlSize(.large)
            
            Button {
                showLog.toggle()
            } label: {
                Image(systemName: "doc.text.below.ecg.fill")
                    .frame(maxWidth: 30, maxHeight: 30)
            }
            .buttonStyle(.bordered)
            .cornerRadius(20)
            .sheet(isPresented: $showLog) {
                LogSheetView()
                    .presentationBackground(.thickMaterial)
            }
            .controlSize(.large)
        }
        .padding(.top, 35)
        .padding(.bottom, 20)
    }
    
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
