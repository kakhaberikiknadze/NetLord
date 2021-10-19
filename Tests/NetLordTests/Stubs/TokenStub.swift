//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 19.10.21.
//

import Foundation
import Combine
@testable import NetLord

struct TokenStub: Tokenable, Codable {
    let value: String
    let expireDate: Date?
    var isValid: Bool {
        guard let expireDate = expireDate else {
            return true
        }
        return expireDate > Date()
    }
    
    func convertToData<E>(encoder: E) throws -> Data where E : TopLevelEncoder, E.Output == Data {
        try encoder.encode(value)
    }
}

extension TokenStub {
    static let validAccessToken: Self = .init(value: "ACCESS_TOKEN", expireDate: nil)
    static let validRefreshToken: Self = .init(value: "REFRESH_TOKEN", expireDate: nil)
}
