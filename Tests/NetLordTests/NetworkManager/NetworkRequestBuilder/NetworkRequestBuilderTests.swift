//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 25.05.21.
//

#if swift(>=5.4)
import Foundation
import XCTest
@testable import NetLord
import Combine

extension NetworkManagerTests {
    
    func testMakeRequest() {
        let session = MockSession(data: nil, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        manager.makeRequest { }
        XCTAssertNotNil(manager.builtRequest)
    }

    func testURL() throws {
        let session = MockSession(data: nil, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        manager.makeRequest {
            Scheme("https")
            Host("example.com")
        }
        let url = try XCTUnwrap(manager.builtRequest?.url)
        XCTAssertEqual("https://example.com", url.absoluteString.removingPercentEncoding)
    }

    func testEndpoint() throws {
        let session = MockSession(data: nil, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        let path = "/path"
        manager.makeRequest {
            Scheme("https")
            Host("example.com")
            Endpoint(path: path)
        }
        let url = try XCTUnwrap(manager.builtRequest?.url)
        let sutPath = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: true)?.path)
        XCTAssertEqual(sutPath, path)
    }

    func testURLPath() throws {
        let session = MockSession(data: nil, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        let path = "/path"
        manager.makeRequest {
            Scheme("https")
            Host("example.com")
            URLPath(path)
        }
        let url = try XCTUnwrap(manager.builtRequest?.url)
        let sutPath = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: true)?.path)
        XCTAssertEqual(sutPath, path)
    }

    func testBuiltRequestHeaders() throws {
        let headers = ["Authorization": "Token"]
        let session = MockSession(data: nil, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        manager.makeRequest {
            Scheme("https")
            Host("example.com")
            Headers(headers)
        }
        let sutHeaders = try XCTUnwrap(manager.builtRequest?.allHTTPHeaderFields)
        XCTAssertEqual(sutHeaders, headers)
    }

    func testCachePolicy() {
        let session = MockSession(data: nil, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        let cachePolicy: CachePolicy = .reloadIgnoringCacheData
        manager.makeRequest {
            Scheme("https")
            Host("example.com")
            Endpoint(path: "/path")
            cachePolicy
        }
        XCTAssertEqual(cachePolicy, manager.builtRequest?.cachePolicy)
    }

    func testHttpBody() {
        let session = MockSession(data: nil, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        let body: Data? = try? JSONEncoder().encode(MockObject())
        manager.makeRequest {
            Scheme("https")
            Host("example.com")
            HTTPBody(body)
        }
        XCTAssertEqual(manager.builtRequest?.httpBody, body)
    }

    func testHttpMethod() {
        let session = MockSession(data: nil, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        let method = "POST"
        manager.makeRequest {
            Scheme("https")
            Host("example.com")
            HTTPMethod(method)
        }
        XCTAssertEqual(manager.builtRequest?.httpMethod, method)
    }

    func testQuery() throws {
        let session = MockSession(data: nil, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        let queries = [URLQueryItem(name: "foo", value: "bar")]
        manager.makeRequest {
            Scheme("https")
            Host("example.com")
            Query(queries)
        }
        let url = try XCTUnwrap(manager.builtRequest?.url)
        let sutQueries = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems)
        XCTAssertEqual(sutQueries, queries)
    }

    func testTimeoutInterval() {
        let session = MockSession(data: nil, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        let interval: TimeInterval = 10
        manager.makeRequest {
            Scheme("https")
            Host("example.com")
            TimeoutInterval(interval)
        }
        XCTAssertEqual(manager.builtRequest?.timeoutInterval, interval)
    }

    func testNetworkRequestSuccess() throws {
        let promise = expectation(description: "Getting mock object")
        let object = MockObject(foo: "bar")
        let data = try JSONEncoder().encode(object)
        let session = MockSession(data: data, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        
        manager.makeRequest {
            Scheme("https")
            Host("example.com")
        }
        .dataTaskPublisher(responseType: MockObject.self)
        .sink { result in
            switch result {
            case .finished:
                promise.fulfill()
            case .failure(let error):
                XCTFail("Expected to succeed network request but it has failed with error: \(error)")
            }
        } receiveValue: { value in
            XCTAssertEqual(object, value)
        }
        .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1)
    }

    func testNetworkRequestFailure() {
        let promise = expectation(description: "Getting failure")
        let session = MockSession(data: nil, response: nil, error: nil)
        let manager = NetworkManager(session: session)
        
        manager.makeRequest {
            Scheme("https")
            Host("example.com")
        }
        .dataTaskPublisher(responseType: MockObject.self)
        .sink { result in
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
#endif
