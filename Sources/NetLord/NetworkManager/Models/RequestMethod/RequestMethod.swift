//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 08.03.21.
//

public struct RequestMethod: Equatable {
    
    public let value: String
    
}

public extension RequestMethod {
    
    static var get: Self { .init(value: "GET") }
    static var post: Self { .init(value: "POST") }
    static var delete: Self { .init(value: "DELETE") }
    static var put: Self { .init(value: "PUT") }
    static var patch: Self { .init(value: "PATCH") }
    
}
