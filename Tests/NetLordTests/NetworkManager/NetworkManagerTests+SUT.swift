//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 09.05.21.
//

//import Foundation
//import Combine
//@testable import NetLord
//
//extension NetworkManagerTests {
//
//    func makeAuthorizer(
//        needsAuth: Bool = true,
//        fails: Bool = false,
//        tokenValue: String = "ACCESS_TOKEN"
//    ) -> Authorizing {
//        class AuthorizerMock: Authorizing {
//            var isSignedIn: Bool
//            private let tokenValue: String
//            private let fails: Bool
//
//            init(tokenValue: String, isSignedIn: Bool = true, fails: Bool) {
//                self.tokenValue = tokenValue
//                self.isSignedIn = isSignedIn
//                self.fails = fails
//            }
//
//            func authorize(_ request: URLRequest) -> AnyPublisher<URLRequest, Error> {
//                if fails {
//                    return Fail(error: NSError(domain: "Fail", code: -1, userInfo: nil))
//                        .eraseToAnyPublisher()
//                } else {
//                    return CurrentValueSubject<HTTPHeaders, Error>(["Authorization": tokenValue])
//                        .eraseToAnyPublisher()
//                }
//            }
//        }
//        return AuthorizerMock(tokenValue: tokenValue, fails: fails)
//    }
//
//}
