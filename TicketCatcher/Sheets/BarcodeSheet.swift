//
//  BarcodeSheetView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/12/24.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct BarcodeSheet: View {
    let numberFont = Font
        .system(size: 28)
        .monospaced()
    var barcodeValue: String
    var barcodeImage: Image? {
        generateBarcode(from: barcodeValue)
    }
    
    var body: some View {
        VStack {
            Text("Below is your generated barcode.\nBe sure to save this image!")
                .font(.headline)
                .foregroundColor(.accentColor)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
            barcodeImage?
                .resizable()
                .scaledToFit()
            Text(barcodeValue)
                .font(numberFont)
                .foregroundColor(.secondary)
            Spacer()
            ShareLink(
                item: (barcodeImage)!,
                preview: SharePreview(
                    "Share Barcode",
                    image: (barcodeImage)!
                )
            )
            .buttonStyle(.borderedProminent)
            .cornerRadius(20)
            .controlSize(.large)
        }
        .padding()
    }
    
    func generateBarcode(from string: String) -> Image? {
        let context = CIContext()
        let filter = CIFilter.code128BarcodeGenerator()
        let data = Data(string.utf8)
        filter.message = data
        filter.quietSpace = 7
        
        guard let barcodeImage = filter.outputImage else { return nil }
        let invertFilter = CIFilter.colorInvert()
        invertFilter.inputImage = barcodeImage
        
        if let outputImage = invertFilter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return Image(uiImage: UIImage(cgImage: cgImage))
        } else {
            return nil
        }
    }
    
}

#Preview {
    BarcodeSheet(barcodeValue: "12345")
}
