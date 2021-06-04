//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 04.06.21.
//

import Foundation
import Combine
@testable import NetLord

internal struct MockObject: Identifiable, Equatable, Codable {
    internal let id: String
    internal let foo: String
    
    internal init(id: String = UUID().uuidString, foo: String = "bar") {
        self.id = id
        self.foo = foo
    }
}

internal final class NetworkManagerMock: NetworkManaging {
    
    internal var fails: Bool = false
    
    func perform<T: Decodable>(
        request: URLRequest,
        responseType: T.Type,
        decoder: JSONDecoder?,
        retryCount: Int,
        needsAuthorization: Bool
    ) -> AnyPublisher<T, Error> {
        guard fails else {
            let data = try! JSONEncoder().encode(["id": "0", "foo": "bar"])
            let result = try! (decoder ?? JSONDecoder()).decode(T.self, from: data)
            return Just(result)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "Error", code: -1, userInfo: nil)).eraseToAnyPublisher()
    }
    
    func download(request: URLRequest, retryCount: Int, needsAuthorization: Bool) -> AnyPublisher<URL, URLError> {
        guard fails else {
            return Just(URL(string: "my/path")!)
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: URLError(.badURL))
            .eraseToAnyPublisher()
    }
    
}
