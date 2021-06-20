//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 25.05.21.
//

#if swift(>=5.4)
import Foundation

public struct Host: RequestBuilding {
    
    private let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    public func buildRequest(_ request: inout URLRequest) {
        guard
            let url = request.url,
            var components = URLComponents(string: url.absoluteString)
        else {
            fatalError("Failed to create URLComponents from request: \(String(describing: request))")
        }
        components.host = value
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        request.url = url
    }
    
}
#endif
