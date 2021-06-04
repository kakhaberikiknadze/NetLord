//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 25.05.21.
//

#if swift(>=5.4)
import Foundation

public struct Headers: RequestBuilding {
    
    private let headers: HTTPHeaders
    private let shouldAppend: Bool
    
    public init(_ headers: HTTPHeaders, append: Bool = true) {
        self.headers = headers
        self.shouldAppend = append
    }
    
    public func buildRequest(_ request: inout URLRequest) {
        guard shouldAppend else {
            request.allHTTPHeaderFields = headers
            return
        }
        appendHeaders(in: &request)
    }
    
    private func appendHeaders(in request: inout URLRequest) {
        headers.forEach { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
    
}
#endif
