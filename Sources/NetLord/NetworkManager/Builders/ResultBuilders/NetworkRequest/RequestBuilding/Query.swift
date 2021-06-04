//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 25.05.21.
//

#if swift(>=5.4)
import Foundation

public struct Query: RequestBuilding {
    
    private let queryItems: [URLQueryItem]
    
    public init(_ parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
    
    public init(_ queryItems: [URLQueryItem]) {
        self.queryItems = queryItems
    }
    
    public func buildRequest(_ request: inout URLRequest) {
        guard
            let url = request.url,
            var components = URLComponents(string: url.absoluteString)
        else {
            fatalError("Failed to create URLComponents from request: \(String(describing: request))")
        }
        components.queryItems = queryItems
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        request.url = url
    }
    
}
#endif
