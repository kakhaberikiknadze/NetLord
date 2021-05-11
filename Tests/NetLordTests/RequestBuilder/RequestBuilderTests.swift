//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 24.04.21.
//

import Foundation
import XCTest
@testable import NetLord

final class RequestBuilderTests: XCTestCase {
    
    func testBuiltRequest() {
        let headers: HTTPHeaders? = ["TestHeader": "TestHeaderValue"]
        let builder = RequestBuilder()
            .setScheme("https")
            .setHost("api.spotify.com")
            .setBasePath("/v1")
            .setEndpooint(.init(path: "/my/path"))
            .setAdditionalHeaders(headers ?? [:])
        let request = builder.build()
        let requestHeadersSet = Set(arrayLiteral: request.allHTTPHeaderFields)
        let headersSet = Set(arrayLiteral: headers)
        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "api.spotify.com")
        XCTAssertEqual(request.url?.path, "/v1/my/path")
        XCTAssertTrue(headersSet.isSubset(of: requestHeadersSet))
    }
    
}
