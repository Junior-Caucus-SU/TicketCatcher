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
    @Published var errorMessage: String?

    private var progressObj = Progress(totalUnitCount: 1)

    ///Upload data from the CSV file and call generator, then upload to CK
    ///If the errors are shown user-side, they're bascially fucked, except for iCloud issues
    func uploadData(url: URL, completion: @escaping () -> Void) {
        isUploading = true
        progress = 0.0
        errorMessage = nil

        let parser = CSVParser()
        let generator = CodeGenerator()

        if let names = parser.parseCSV(contentsOfURL: url, encoding: .utf8) {
            progressObj = Progress(totalUnitCount: Int64(names.count))
            var currentCount = 0
            
            for name in names {
                let barcode = generator.generateUniqueCode()
                CKManager.shared.addCodenameRecord(name: name, barcode: Int(barcode)) { error in
                    DispatchQueue.main.async {
                        if let error = error {
                            self.errorMessage = "Error: \(error.localizedDescription). Have you signed in to your iCloud account on this device?"
                            self.isUploading = false
                            return
                        }

                        currentCount += 1
                        self.progressObj.completedUnitCount = Int64(currentCount)
                        self.progress = Double(self.progressObj.fractionCompleted)
                        
                        if currentCount == names.count {
                            self.isUploading = false
                            self.uploadCompleted = true
                            completion()
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid CSV File."
                self.isUploading = false
            }
        }
    }
}
