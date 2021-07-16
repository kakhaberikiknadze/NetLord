//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 25.05.21.
//

#if swift(>=5.4)
import Foundation

public struct HTTPBody: RequestBuilding {
    private let data: Data?
    
    public init(_ data: Data?) {
        self.data = data
    }
    
    public init(_ dictionary: [String: Any]) {
        data = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: .prettyPrinted
        )
    }
    
    public init<T: Encodable>(
        _ value: T,
        encoder: JSONEncoder = .init()
    ) {
        data = try? encoder.encode(value)
    }
    
    public init(_ string: String) {
        data = string.data(using: .utf8)
    }
    
    public init(_ queries: [URLQueryItem]) {
        var components = URLComponents()
        components.queryItems = queries
        data = components.query?.data(using: .utf8)
    }
    
    public func buildRequest(_ request: inout URLRequest) {
        request.httpBody = data
    }
}
#endif
