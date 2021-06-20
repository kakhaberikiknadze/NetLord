//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 25.05.21.
//

#if swift(>=5.4)
import Foundation

public struct HTTPMethod: RequestBuilding {
    
    private let method: String
    
    public init(_ method: String) {
        self.method = method
    }
    
    public init(_ method: RequestMethod) {
        self.method = method.value
    }
    
    public func buildRequest(_ request: inout URLRequest) {
        request.httpMethod = method
    }
    
}
#endif
