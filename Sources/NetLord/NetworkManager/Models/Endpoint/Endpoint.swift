//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 08.03.21.
//

import Foundation

public struct Endpoint {
    
    public let method: RequestMethod
    public let path: String
    public let queryItems: [URLQueryItem]?
    
    public init(
        method: RequestMethod = .get,
        path: String,
        queryItems: [URLQueryItem]? = nil
    ) {
        self.path = path
        self.queryItems = queryItems
        self.method = method
    }
    
}
