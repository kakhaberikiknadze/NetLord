//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 25.05.21.
//

import Foundation
import XCTest
@testable import NetLord
import Combine

final class NetworkRequestBuilderTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func tearDown() {
        cancellables = []
    }
    
    func testURL() throws {
        let manager = NetworkManagerMock()
        let request = NetworkRequest<MockObject>(manager: manager) {
            Scheme("https")
            Host("example.com")
        }
        .build()
        let url = try XCTUnwrap((request).url)
        XCTAssertEqual("https://example.com", url.absoluteString.removingPercentEncoding)
    }
    
    func testEndpoint() throws {
        let manager = NetworkManagerMock()
        let path = "/path"
        let request = NetworkRequest<MockObject>(manager: manager) {
            Scheme("https")
            Host("example.com")
            Endpoint(path: path)
        }
        .build()
        let url = try XCTUnwrap((request).url)
        let sutPath = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: true)?.path)
        XCTAssertEqual(sutPath, path)
    }
    
    func testURLPath() throws {
        let manager = NetworkManagerMock()
        let path = "/path"
        let request = NetworkRequest<MockObject>(manager: manager) {
            Scheme("https")
            Host("example.com")
            URLPath(path)
        }
        .build()
        let url = try XCTUnwrap((request).url)
        let sutPath = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: true)?.path)
        XCTAssertEqual(sutPath, path)
    }
    
    func testBuiltRequestHeaders() throws {
        let headers = ["Authorization": "Token"]
        let manager = NetworkManagerMock()
        let request = NetworkRequest<MockObject>(manager: manager) {
            Scheme("https")
            Host("example.com")
            Headers(headers)
        }
        .build()
        let sutHeaders = try XCTUnwrap(request.allHTTPHeaderFields)
        XCTAssertEqual(sutHeaders, headers)
    }
    
    func testCachePolicy() {
        let manager = NetworkManagerMock()
        let cachePolicy: CachePolicy = .reloadIgnoringCacheData
        let request = NetworkRequest<MockObject>(manager: manager) {
            Scheme("https")
            Host("example.com")
            Endpoint(path: "/path")
            cachePolicy
        }
        .build()
        XCTAssertEqual(cachePolicy, request.cachePolicy)
    }
    
    func testHttpBody() {
        let manager = NetworkManagerMock()
        let body: Data? = try? JSONEncoder().encode(MockObject())
        let request = NetworkRequest<MockObject>(manager: manager) {
            Scheme("https")
            Host("example.com")
            HTTPBody(body)
        }
        .build()
        XCTAssertEqual(request.httpBody, body)
    }
    
    func testHttpMethod() {
        let manager = NetworkManagerMock()
        let method = "POST"
        let request = NetworkRequest<MockObject>(manager: manager) {
            Scheme("https")
            Host("example.com")
            HTTPMethod(method)
        }
        .build()
        XCTAssertEqual(request.httpMethod, method)
    }
    
    func testQuery() throws {
        let manager = NetworkManagerMock()
        let queries = [URLQueryItem(name: "foo", value: "bar")]
        let request = NetworkRequest<MockObject>(manager: manager) {
            Scheme("https")
            Host("example.com")
            Query(queries)
        }
        .build()
        let url = try XCTUnwrap((request).url)
        let sutQueries = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems)
        XCTAssertEqual(sutQueries, queries)
    }
    
    func testTimeoutInterval() {
        let manager = NetworkManagerMock()
        let interval: TimeInterval = 10
        let request = NetworkRequest<MockObject>(manager: manager) {
            Scheme("https")
            Host("example.com")
            TimeoutInterval(interval)
        }
        .build()
        XCTAssertEqual(request.timeoutInterval, interval)
    }

    func testNetworkRequestSuccess() {
        let promise = expectation(description: "Getting mock object")
        let manager = NetworkManagerMock()
        NetworkRequest<MockObject>(manager: manager) {
            Scheme("https")
            Host("example.com")
        }
        .onSuccess { _ in
            promise.fulfill()
        }
        .onError { _ in
            XCTFail("Expected to succeed network request but it failed")
        }
        .perform()
        wait(for: [promise], timeout: 1)
    }
    
    func testNetworkRequestFailure() {
        let promise = expectation(description: "Getting failure")
        let manager = NetworkManagerMock()
        manager.fails = true
        NetworkRequest<MockObject>(manager: manager) {
            Scheme("https")
            Host("example.com")
        }
        .onSuccess { _ in
            XCTFail("Expected to fail network request but it succeeded")
        }
        .onError { _ in
            promise.fulfill()
        }
        .perform()
        wait(for: [promise], timeout: 1)
    }
    
}
