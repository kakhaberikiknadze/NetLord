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
    
    func testDataTask_Success() throws {
        let object = Dummy.stubbed
        let data = try JSONEncoder().encode(object)
        let url = try XCTUnwrap(URL(string: "https://example.com"))
        let session = MockSession(data: data, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        let request = URLRequest(url: url)
        let promise = expectation(description: "Performing network request to succeed")
        
        let publisher: AnyPublisher<Dummy, Error> = manager.perform(request: request)
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
    
    func testDataTask_Failure() throws {
        let url = try XCTUnwrap(URL(string: "https://example.com"))
        let session = MockSession(data: nil, response: nil, error: URLError(.unknown))
        let manager = NetworkManager(session: session)
        let request = URLRequest(url: url)
        let promise = expectation(description: "Performing network request to fail")
        
        let publisher: AnyPublisher<Dummy, Error> = manager.perform(request: request)
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
    
    func testDownloadTask_Success() throws {
        let responseUrl = try XCTUnwrap(URL(string: "my/path"))
        let requestUrl = try XCTUnwrap(URL(string: "https://example.com"))
        let session = MockSession(url: responseUrl, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        let request = URLRequest(url: requestUrl)
        let promise = expectation(description: "Performing download task to succeed")
        
        let publisher: AnyPublisher<URL, URLError> = manager.download(request: request)
        publisher.sink { result in
            switch result {
            case .finished:
                promise.fulfill()
            case .failure:
                XCTFail("Expected to succeed download task but it failed")
            }
        } receiveValue: { url in
            XCTAssertEqual(url, responseUrl)
        }
        .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1)
    }
    
    func testDownloadTask_Failure() throws {
        let requestUrl = try XCTUnwrap(URL(string: "https://example.com"))
        let session = MockSession(url: nil, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        let request = URLRequest(url: requestUrl)
        let promise = expectation(description: "Performing download task to fail")
        
        let publisher: AnyPublisher<URL, URLError> = manager.download(request: request)
        publisher.sink { result in
            switch result {
            case .finished:
                XCTFail("Expected to fail download task but it succeeded")
            case .failure:
                promise.fulfill()
            }
        } receiveValue: { _ in }
        .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1)
    }
    
}
