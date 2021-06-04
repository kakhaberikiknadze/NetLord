//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 04.06.21.
//

import Combine
import Foundation

public protocol NetworkManaging: AnyObject {
    func perform<T: Decodable>(
        request: URLRequest,
        responseType: T.Type,
        decoder: JSONDecoder?,
        retryCount: Int,
        needsAuthorization: Bool
    ) -> AnyPublisher<T, Error>
    
    func download(
        request: URLRequest,
        retryCount: Int,
        needsAuthorization: Bool
    ) -> AnyPublisher<URL, URLError>
}

public extension NetworkManaging {
    func perform<T: Decodable>(request: URLRequest) -> AnyPublisher<T, Error> {
        perform(request: request, responseType: T.self, decoder: nil, retryCount: .zero, needsAuthorization: true)
    }
    
    func perform<T: Decodable>(request: URLRequest, responseType: T.Type) -> AnyPublisher<T, Error> {
        perform(request: request, responseType: responseType, decoder: nil, retryCount: .zero, needsAuthorization: true)
    }
    
    func perform<T: Decodable>(request: URLRequest, retryCount: Int) -> AnyPublisher<T, Error> {
        perform(request: request, responseType: T.self, decoder: nil, retryCount: retryCount, needsAuthorization: true)
    }
    
    func perform<T: Decodable>(request: URLRequest, needsAuthorization: Bool) -> AnyPublisher<T, Error> {
        perform(request: request, responseType: T.self, decoder: nil, retryCount: .zero, needsAuthorization: needsAuthorization)
    }
}

public extension NetworkManaging {
    func download(request: URLRequest, needsAuthorization: Bool) -> AnyPublisher<URL, URLError> {
        download(request: request, retryCount: .zero, needsAuthorization: needsAuthorization)
    }
    
    func download(request: URLRequest, retryCount: Int) -> AnyPublisher<URL, URLError> {
        download(request: request, retryCount: retryCount, needsAuthorization: true)
    }
}
