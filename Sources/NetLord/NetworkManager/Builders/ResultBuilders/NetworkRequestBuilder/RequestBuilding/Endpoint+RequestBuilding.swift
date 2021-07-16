//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 25.05.21.
//

#if swift(>=5.4)
import Foundation

extension Endpoint: RequestBuilding {
    
    public func buildRequest(_ request: inout URLRequest) {
        guard
            let url = request.url,
            var components = URLComponents(string: url.absoluteString)
        else {
            fatalError("Failed to create URLComponents from request: \(String(describing: request))")
        }
        components.path = path
        if method == .get {
            components.queryItems = queryItems
        } else {
            do {
                var components = URLComponents()
                components.queryItems = queryItems
                request.httpBody = components.query?.data(using: .utf8)
            }
        }
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        request.url = url
        request.httpMethod = method.rawValue
    }
    
}
#endif
