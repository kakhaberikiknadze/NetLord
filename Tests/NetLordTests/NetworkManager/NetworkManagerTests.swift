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
    
    func testDataTaskSuccess() throws {
        let object = MockObject(foo: "bar")
        let data = try JSONEncoder().encode(object)
        let url = try XCTUnwrap(URL(string: "https://example.com"))
        let session = MockSession(data: data, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        
        let request = URLRequest(url: url)
        let promise = expectation(description: "Performing network request to succeed")
        
        let publisher: AnyPublisher<MockObject, Error> = manager.perform(request: request)
        publisher.sink { result in
            switch result {
            case .finished:
                promise.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
        } receiveValue: { result in
            XCTAssertEqual(result, object)
        }
        .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1)
    }
    
    func testDataTaskFailure() throws {
        let url = try XCTUnwrap(URL(string: "https://example.com"))
        let session = MockSession(data: nil, response: nil, error: URLError(.unknown))
        let manager = NetworkManager(session: session)
        
        let request = URLRequest(url: url)
        let promise = expectation(description: "Performing network request to fail")
        
        let publisher: AnyPublisher<MockObject, Error> = manager.perform(request: request)
        publisher.sink { result in
            switch result {
            case .finished:
                XCTFail("Expected to fail network request but it has succeeded")
            case .failure:
                promise.fulfill()
            }
            
        } receiveValue: { _ in }
        .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1)
    }
    
}
