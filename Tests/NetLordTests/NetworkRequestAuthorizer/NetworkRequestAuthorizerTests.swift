//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 19.10.21.
//

import Foundation
import XCTest
import Combine
@testable import NetLord

final class NetworkRequestAuthorizerTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    override func tearDown() {
        cancellables = []
    }
    
    func testAuthorizerInit_Closure() {
        let store = MockTokenStore()
        let refreshToken = TokenStub.validRefreshToken
        store.refreshToken = refreshToken
        let refreshedToken = TokenStub.validAccessToken
        
        let authorizer = NetworkRequestAuthorizer(tokenStore: store) { token in
            XCTAssertEqual(refreshToken.value, token)
            return Just(refreshedToken)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        authorizer.refreshToken()
            .sink { completion in
                guard case let .failure(error) = completion else {
                    return
                }
                XCTFail(error.localizedDescription)
            } receiveValue: { accessToken in
                XCTAssertEqual(accessToken.value, refreshedToken.value)
                XCTAssertEqual(accessToken.expireDate, refreshedToken.expireDate)
                XCTAssertEqual(accessToken.isValid, refreshedToken.isValid)
            }
            .store(in: &cancellables)
    }
    
    func testAuthorizerInit_TokenRefresher() {
        let store = MockTokenStore()
        let refreshToken = TokenStub.validRefreshToken
        store.refreshToken = refreshToken
        let refreshedToken = TokenStub.validAccessToken
        let refresher = MockTokenRefresher(refreshedAccessToken: refreshedToken)
        
        let authorizer = NetworkRequestAuthorizer(
            tokenStore: store,
            tokenRefresher: refresher
        )
        
        authorizer.refreshToken()
            .sink { completion in
                guard case let .failure(error) = completion else {
                    return
                }
                XCTFail(error.localizedDescription)
            } receiveValue: { accessToken in
                XCTAssertEqual(accessToken.value, refreshedToken.value)
                XCTAssertEqual(accessToken.expireDate, refreshedToken.expireDate)
                XCTAssertEqual(accessToken.isValid, refreshedToken.isValid)
            }
            .store(in: &cancellables)
    }
}

