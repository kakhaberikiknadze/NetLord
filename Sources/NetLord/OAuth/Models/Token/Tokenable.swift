//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 09.05.21.
//

import Foundation
import Combine

public protocol Tokenable: Codable {
    var value: String { get }
    var expireDate: Date? { get }
    var isValid: Bool { get }
    func convertToData<E>(encoder: E) throws -> Data where E: TopLevelEncoder, E.Output == Data
}
