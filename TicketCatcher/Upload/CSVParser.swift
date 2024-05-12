//
//  CSVParser.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 2/12/24.
//

import Foundation

class CSVParser {
    func parseCSV(contentsOfURL: URL, encoding: String.Encoding) -> [String]? {
        do {
            let content = try String(contentsOf: contentsOfURL, encoding: encoding)
            var rows = content.components(separatedBy: "\n")
            rows = rows.filter { !$0.isEmpty }
            return rows.map { $0.components(separatedBy: ",")[15] } //assume name column is the 16th column
        } catch {
            print("Error reading CSV file: \(error)")
            return nil
        }
    }
}
