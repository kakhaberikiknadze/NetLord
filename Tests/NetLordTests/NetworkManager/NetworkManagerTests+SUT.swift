//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 09.05.21.
//

import Foundation
import Combine
@testable import NetLord

extension NetworkManagerTests {
    
    func makeAuthorizer(
        needsAuth: Bool = true,
        fails: Bool = false,
        tokenValue: String = "ACCESS_TOKEN"
    ) -> Authorizing {
        class AuthorizerMock: Authorizing {
            var isSignedIn: Bool
            var needsAuth: Bool
            private let tokenValue: String
            private let fails: Bool
            
            init(needsAuth: Bool, tokenValue: String, isSignedIn: Bool = true, fails: Bool) {
                self.needsAuth = needsAuth
                self.tokenValue = tokenValue
                self.isSignedIn = isSignedIn
                self.fails = fails
            }
            
            func authorize() -> AnyPublisher<HTTPHeaders, Error> {
                if fails {
                    return Fail(error: NSError(domain: "Fail", code: -1, userInfo: nil))
                        .eraseToAnyPublisher()
                } else {
                    return CurrentValueSubject<HTTPHeaders, Error>(["Authorization": tokenValue])
                        .eraseToAnyPublisher()
                }
            }
        }
        return AuthorizerMock(needsAuth: needsAuth, tokenValue: tokenValue, fails: fails)
    }
    
}
