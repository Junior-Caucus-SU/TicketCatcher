//
//  CodeGenerator.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/11/24.
//

import Foundation

class CodeGenerator {
    ///Generates a unique 9-digit code
    ///Replace with OSIS
    func generateUniqueCode() -> Int {
        return Int.random(in: 100000000..<999999999)
    }
}
