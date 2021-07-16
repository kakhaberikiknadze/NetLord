//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 16.07.21.
//

import Foundation

internal struct Dummy: Identifiable, Equatable, Codable {
    let id: UUID
    let foo: String
    
    internal init(id: UUID = .init(), foo: String) {
        self.id = id
        self.foo = foo
    }
    
    static let stubbed: Self = .init(foo: "bar")
}
