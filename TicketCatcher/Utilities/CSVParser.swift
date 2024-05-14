//
//  CSVParser.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 2/12/24.
//

import Foundation

class CSVParser {
    func parseCSV(contentsOfURL: URL, encoding: String.Encoding) -> [(name: String, barcode: String)]? {
        do {
            let content = try String(contentsOf: contentsOfURL, encoding: encoding)
            var rows = content.components(separatedBy: "\n")
            rows = rows.filter { !$0.isEmpty }
            return rows.map { row in
                let columns = row.components(separatedBy: ",")
                let name = columns[15]
                let barcode = columns[16]
                return (name, barcode)
            }
        } catch {
            LogManager.shared.log("Error reading CSV file: \(error)")
            return nil
        }
    }
}
