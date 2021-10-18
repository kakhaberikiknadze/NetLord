//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 08.03.21.
//

import Foundation
import Combine

public extension NetworkManager {
    
    func perform<T: Decodable>(
        request: URLRequest,
        responseType: T.Type = T.self,
        decoder: JSONDecoder? = nil,
        retryCount: Int = .zero,
        needsAuthorization: Bool = true
    ) -> AnyPublisher<T, Error> {
        let decoder = decoder ?? self.decoder
        if needsAuthorization, let authorizer = authorizer {
            return authorizer.authorize(request)
                .flatMap { [weak self] authorizedRequest in
                    self?.perform(
                        request: authorizedRequest,
                        responseType: responseType,
                        decoder: decoder,
                        retryCount: retryCount
                    )
                    ?? PassthroughSubject<T, Error>().eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        } else {
            return perform(request: request, responseType: responseType, decoder: decoder, retryCount: retryCount)
        }
    }
    
    private func perform<T: Decodable>(
        request: URLRequest,
        responseType: T.Type = T.self,
        decoder: JSONDecoder,
        retryCount: Int = .zero
    ) -> AnyPublisher<T, Error> {
        session.dataTask(for: request)
            .print("Perform Network Request")
            .retry(retryCount)
            .validateNetworkResponse()
            .decode(type: T.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

}
