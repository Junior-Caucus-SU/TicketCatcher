//
//  CSVParser.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 2/12/24.
//

import Foundation

class CSVParser {
    func parseCSV(contentsOfURL: URL, encoding: String.Encoding) -> [(name: String, barcode: String, validity: String)]? {
        do {
            let content = try String(contentsOf: contentsOfURL, encoding: encoding)
            var rows = content.components(separatedBy: "\n")
            rows = rows.filter { !$0.isEmpty }
            return rows.enumerated().compactMap { (rowIndex, row) in
                let columns = parseCSVRow(row, rowIndex: rowIndex)
                guard columns.count > 16 else { return nil }
                let validity = columns[13]
                let name = columns[15]
                let barcode = columns[16]
                return (name, barcode, validity)
            }
        } catch {
            LogManager.shared.log("Error reading CSV file: \(error)")
            return nil
        }
    }
    
    ///Handle commas in addresses
    private func parseCSVRow(_ row: String, rowIndex: Int) -> [String] {
        var result: [String] = []
        var current = ""
        var quoted = false
        var prev: Character = "\0"
        
        for char in row {
            if char == "\"" {
                LogManager.shared.log("Found quotes in CSV file on row \(rowIndex). Ignoring commas between.")
                if quoted && prev == "\"" {
                    current.append(char)
                }
                quoted.toggle()
            } else if char == "," && !quoted {
                result.append(current)
                current = ""
            } else {
                current.append(char)
            }
            prev = char
        }
        result.append(current)
        return result
    }
}
