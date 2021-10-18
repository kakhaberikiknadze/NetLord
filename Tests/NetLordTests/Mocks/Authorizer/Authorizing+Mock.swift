//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 18.10.21.
//

import Foundation
import Combine
@testable import NetLord

class MockAuthorizer: Authorizing {
    var isSignedIn: Bool
    var tokenValue: String
    var fails: Bool
    
    init(
        isSignedIn: Bool = true,
        tokenValue: String = "ACCESS_TOKEN",
        fails: Bool = false
    ) {
        self.isSignedIn = isSignedIn
        self.tokenValue = tokenValue
        self.fails = fails
    }
    
    func authorize(_ request: URLRequest) -> AnyPublisher<URLRequest, Error> {
        Future { [tokenValue, fails] promise in
            if fails {
                let error = NSError(domain: "Failed to authorize an access token", code: -1, userInfo: nil)
                promise(.failure(error))
            } else {
                var newRequest = request
                newRequest.setValue("Bearer " + tokenValue, forHTTPHeaderField: "Authorization")
                promise(.success(newRequest))
            }
        }
        .eraseToAnyPublisher()
    }
}
