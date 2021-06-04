//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 25.05.21.
//

#if swift(>=5.4)
import Foundation

public typealias CachePolicy = URLRequest.CachePolicy

extension URLRequest.CachePolicy: RequestBuilding {
    
    public func buildRequest(_ request: inout URLRequest) {
        request.cachePolicy = self
    }
    
}

#endif
