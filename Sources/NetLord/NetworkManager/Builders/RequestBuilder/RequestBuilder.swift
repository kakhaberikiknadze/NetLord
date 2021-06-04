//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 19.04.21.
//

import Foundation

public final class RequestBuilder {
    
    private var scheme: String = ""
    private var host: String = ""
    private var basePath: String = ""
    private var endpoint: Endpoint = .init(path: "")
    private var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    private var timeoutInterval: TimeInterval = 60.0
    private var additionalHeaders: HTTPHeaders?
    
    public init() {}
    
    public func build() -> URLRequest {
        var httpBody: Data?
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = basePath + endpoint.path
        if endpoint.method == .get {
            components.queryItems = endpoint.queryItems
        } else {
            do {
                var components = URLComponents()
                components.queryItems = endpoint.queryItems
                httpBody = components.query?.data(using: .utf8)
            }
        }
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        var request = URLRequest(
            url: url,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )
        request.httpBody = httpBody
        request.httpMethod = endpoint.method.value
        if let headers = additionalHeaders {
            appendHeaders(headers, in: &request)
        }
        return request
    }
    
    internal func appendHeaders(_ headers: HTTPHeaders, in request: inout URLRequest) {
        headers.forEach { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
    
}

public extension RequestBuilder {
    
    func setScheme(_ scheme: String) -> Self {
        self.scheme = scheme
        return self
    }
    
    func setHost(_ host: String) -> Self {
        self.host = host
        return self
    }
    
    func setBasePath(_ path: String) -> Self {
        basePath = path
        return self
    }
    
    func setEndpooint(_ endpoint: Endpoint) -> Self {
        self.endpoint = endpoint
        return self
    }
    
    func setAdditionalHeaders(_ headers: HTTPHeaders) -> Self {
        self.additionalHeaders = headers
        return self
    }
    
}
