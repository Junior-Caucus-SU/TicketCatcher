//
//  BarcodeView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/12/24.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct BarcodeSheetView: View {
    var barcodeValue: String
    var barcodeImage: Image? {
        generateBarcode(from: barcodeValue)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                barcodeImage?
                    .resizable()
                    .scaledToFit()
                    .padding()
                Text(barcodeValue)
                    .padding()
            }
            .navigationTitle("Barcode")
        }
    }
    
    func generateBarcode(from string: String) -> Image? {
        let context = CIContext()
        let filter = CIFilter.code128BarcodeGenerator()
        let data = Data(string.utf8)
        filter.message = data
        filter.quietSpace = 7
        
        if let outputImage = filter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return Image(uiImage: UIImage(cgImage: cgImage))
        } else {
            return nil
        }
    }

}

#Preview {
    BarcodeSheetView(barcodeValue: "12345")
}
