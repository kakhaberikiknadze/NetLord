//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 09.05.21.
//

import Foundation

public struct Token: Codable {

    public let value: String
    public let type: TokenType
    public let expireDate: Date?

    public init(
        _ value: String,
        type: TokenType,
        expireDate: Date? = nil
    ) {
        self.value = value
        self.type = type
        self.expireDate = expireDate
    }

}

public extension Token {

    var isValid: Bool {
        guard let expDate = expireDate else { return true }
        return Date() < expDate
    }

}
