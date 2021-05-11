//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 24.04.21.
//

import XCTest

final class TokenTests: XCTestCase {
    
    // MARK: - Validity
    func testTokenWithoutExpiryValidity() {
        let sut = makeSut()
        XCTAssertTrue(sut.isValid)
    }
    
    func testExpiredTokenValidity() {
        let sut = makeSut(expirationType: .expired)
        XCTAssertFalse(sut.isValid)
    }
    
    func testUnexpiredTokenValidity() {
        let sut = makeSut(expirationType: .unexpired)
        XCTAssertTrue(sut.isValid)
    }
    
    // MARK: - Type
    func testAccessTokenType() {
        let sut = makeSut()
        XCTAssertEqual(sut.type, .access)
    }
    
    func testRefreshTokenType() {
        let sut = makeSut(.refresh)
        XCTAssertEqual(sut.type, .refresh)
    }
    
}


