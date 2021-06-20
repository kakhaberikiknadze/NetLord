//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 14.06.21.
//

import Foundation
import Combine

public extension NetworkManager {
    
    func upload<R: Decodable>(
        request: URLRequest,
        bodyData: Data?,
        retryCount: Int = .zero,
        needsAuthorization: Bool = true
    ) -> AnyPublisher<R, Error> {
        if needsAuthorization, let authorizer = authorizer {
            return authorizer.authorize()
                .mapError { _ in URLError(.userAuthenticationRequired )}
                .flatMap { [weak self] authorizationHeaders -> AnyPublisher<R, Error> in
                    var newRequest = request
                    authorizationHeaders.forEach {
                        newRequest.setValue($0.value, forHTTPHeaderField: $0.key)
                    }
                    return self?.upload(
                        request: newRequest,
                        bodyData: bodyData,
                        retryCount: retryCount
                    ) ?? PassthroughSubject<R, Error>().eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        } else {
            return upload(request: request, bodyData: bodyData, retryCount: retryCount)
        }
    }
    
    private func upload<R: Decodable>(
        request: URLRequest,
        bodyData: Data?,
        retryCount: Int = .zero
    ) -> AnyPublisher<R, Error> {
        return session.uploadTask(for: request, with: bodyData)
            .print("Perform Upload Request")
            .retry(retryCount)
            .validateNetworkResponse()
            .decode(type: R.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

}
