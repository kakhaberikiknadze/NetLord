//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 24.04.21.
//

import Foundation
@testable import NetLord

extension TokenTests {
    
    enum ExpirationType {
        case noExp, expired, unexpired
    }
    
    func makeSut(
        _ tokenType: TokenType = .access,
        expirationType: ExpirationType = .noExp
    ) -> Token {
        let date = makeExpiryDate(expirationType)
        return Token("test", type: tokenType, expireDate: date)
    }
    
    func makeExpiryDate(_ type: ExpirationType) -> Date? {
        switch type {
        case .noExp:
            return nil
        case .expired:
            return Date().addingTimeInterval(-200)
        case .unexpired:
            return Date().addingTimeInterval(200)
        }
    }
    
}
