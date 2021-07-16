//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 04.06.21.
//

import Foundation
import Combine
@testable import NetLord

internal struct MockObject: Identifiable, Equatable, Codable {
    internal let id: String
    internal let foo: String
    
    internal init(id: String = UUID().uuidString, foo: String = "bar") {
        self.id = id
        self.foo = foo
    }
}
