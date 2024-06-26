//
//  UploadManager.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 1/25/24.
//

import Combine
import Foundation

class UploadManager: ObservableObject {
    @Published var progress: Double = 0.0
    @Published var isUploading: Bool = false
    @Published var uploadCompleted: Bool = false
    
    private var progressObj = Progress(totalUnitCount: 1)
    
    ///Get data from a file URL then upload to CK. If an error happens here, you're bascially fucked, except for iCloud issues
    func uploadData(url: URL, completion: @escaping () -> Void) {
        isUploading = true
        progress = 0.0
        
        let parser = CSVParser()
        
        if let records = parser.parseCSV(contentsOfURL: url, encoding: .utf8) {
            let validRecords = records.filter { $0.validity.contains("Approved") }
            progressObj = Progress(totalUnitCount: Int64(validRecords.count))
            var currentCount = 0
            
            for record in validRecords {
                let (name, osis, validity, barcodeString) = record
                CKManager.shared.addCodenameRecord(name: name, osis: osis, validity: validity, barcode: barcodeString) { error in
                    DispatchQueue.main.async {
                        if let error = error {
                            LogManager.shared.log("Error: \(error.localizedDescription). Have you signed in to your iCloud account on this device?")
                            self.isUploading = false
                            return
                        }
                        //Keep track of progress amount for the progress display.
                        currentCount += 1
                        self.progressObj.completedUnitCount = Int64(currentCount)
                        self.progress = Double(self.progressObj.fractionCompleted)
                        
                        if currentCount == validRecords.count {
                            self.isUploading = false
                            self.uploadCompleted = true
                            completion()
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                LogManager.shared.log("Invalid CSV File.")
                self.isUploading = false
            }
        }
    }
    
}
