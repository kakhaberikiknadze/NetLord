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
    
    func testDownloadTaskSuccess() throws {
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
                XCTFail("Expected to succeed download task but it has failed")
            }
        } receiveValue: { url in
            XCTAssertEqual(url, responseUrl)
        }
        .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1)
    }
    
    func testDownloadTaskFailure() throws {
        let requestUrl = try XCTUnwrap(URL(string: "https://example.com"))
        let session = MockSession(url: nil, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        let request = URLRequest(url: requestUrl)
        let promise = expectation(description: "Performing download task to fail")
        
        let publisher: AnyPublisher<URL, URLError> = manager.download(request: request)
        publisher.sink { result in
            switch result {
            case .finished:
                XCTFail("Expected to fail download task but it has succeeded")
            case .failure:
                promise.fulfill()
            }
        } receiveValue: { _ in }
        .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1)
    }
    
    func testUploadTaskSuccess() throws {
        let requestUrl = try XCTUnwrap(URL(string: "https://example.com"))
        let object = MockObject(foo: "bar")
        let data = try JSONEncoder().encode(object)
        let session = MockSession(data: data, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        let request = URLRequest(url: requestUrl)
        let promise = expectation(description: "Performing upload task to succeed")
        
        let publisher: AnyPublisher<MockObject, Error> = manager.upload(request: request, bodyData: data)
        publisher.sink { result in
            guard case let .failure(error) = result else {
                promise.fulfill()
                return
            }
            XCTFail("Expected to pass upload task but it has failed with error: \(error.localizedDescription)")
        } receiveValue: { value in
            XCTAssertEqual(value, object)
        }
        .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1)
    }
    
    func testUploadTaskFailure() throws {
        let requestUrl = try XCTUnwrap(URL(string: "https://example.com"))
        let object = MockObject(foo: "bar")
        let data = try JSONEncoder().encode(object)
        let session = MockSession(data: nil, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        let request = URLRequest(url: requestUrl)
        let promise = expectation(description: "Performing upload task to fail")
        
        let publisher: AnyPublisher<Data, Error> = manager.upload(request: request, bodyData: data)
        publisher.sink { result in
            guard case .finished = result else {
                promise.fulfill()
                return
            }
            XCTFail("Expected to fail upload task but it has succeeded")
        } receiveValue: { _ in }
        .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1)
    }
    
}
