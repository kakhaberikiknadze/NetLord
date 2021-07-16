//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 20.06.21.
//

#if swift(>=5.4)
import Foundation
import Combine

extension NetworkManager {
    @discardableResult public func makeRequest(
        @NetworkRequestBuilder _ requestBlock: () -> RequestBuilding
    ) -> Self {
        var request = URLRequest(url: URL(string: "https://")!)
        requestBlock().buildRequest(&request)
        builtRequest = request
        return self
    }
    
    public func dataTaskPublisher<R: Decodable>(
        responseType: R.Type = R.self,
        decoder: JSONDecoder? = nil,
        retryCount: Int = .zero,
        needsAuthorization: Bool = true
    ) -> AnyPublisher<R, Error> {
        guard let request = builtRequest else {
            let error = NSError(domain: "Could not find a request", code: -1, userInfo: nil)
            return Fail(error: error).eraseToAnyPublisher()
        }
        return perform(
            request: request,
            responseType: responseType,
            decoder: decoder,
            retryCount: retryCount,
            needsAuthorization: needsAuthorization
        )
        .eraseToAnyPublisher()
    }
    
    public func downloadTaskPublisher(
        retryCount: Int = .zero,
        needsAuthorization: Bool = true
    ) -> AnyPublisher<URL, URLError> {
        guard let request = builtRequest else {
            let error = URLError(.unsupportedURL)
            return Fail(error: error).eraseToAnyPublisher()
        }
        return download(
            request: request,
            retryCount: retryCount,
            needsAuthorization: needsAuthorization
        )
        .eraseToAnyPublisher()
    }
}
#endif
