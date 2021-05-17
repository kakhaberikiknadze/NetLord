//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 09.05.21.
//

import Foundation
import XCTest
import Combine
@testable import NetLord

final class NetworkManagerTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func tearDown() {
        cancellables = []
    }
    
    func testRequestAuthorization() {
        let request = URLRequest(url: URL(string: "https://example.com")!)
        let tokenValue = "ACCESS_TOKEN"
        let authorizer: Authorizing = makeAuthorizer(fails: false, tokenValue: tokenValue)
        let manager = NetworkManager(session: URLSession(configuration: .default), authorizer: authorizer)
        manager.perform(
            request: request,
            responseType: Data.self,
            decoder: nil,
            retryCount: 0,
            needsAuthorization: true
        )
        .sink { result in
            guard case .failure = result else { return }
            XCTFail("Expected Authorizer not to fail but it failed")
        } receiveValue: { _ in }
        .store(in: &cancellables)
    }
    
}
