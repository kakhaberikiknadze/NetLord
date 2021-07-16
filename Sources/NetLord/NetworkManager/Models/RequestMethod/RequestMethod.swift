//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 08.03.21.
//

public struct RequestMethod: Equatable, RawRepresentable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public extension RequestMethod {
    static var get: Self { .init(rawValue: "GET") }
    static var post: Self { .init(rawValue: "POST") }
    static var delete: Self { .init(rawValue: "DELETE") }
    static var put: Self { .init(rawValue: "PUT") }
    static var patch: Self { .init(rawValue: "PATCH") }
}
