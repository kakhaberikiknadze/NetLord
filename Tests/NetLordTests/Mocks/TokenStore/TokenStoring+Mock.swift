//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 19.10.21.
//

import Foundation
@testable import NetLord

class MockTokenStore: TokenStoring {
    var accessToken: Tokenable?
    var refreshToken: Tokenable?
    
    func storeAccessToken(_ token: Tokenable) throws {
        accessToken = token
    }
    
    func storeRefreshToken(_ token: Tokenable) throws {
        refreshToken = token
    }
    
    func getAccessToken() -> Tokenable? {
        accessToken
    }
    
    func getRefreshToken() -> Tokenable? {
        refreshToken
    }
    
    func removeAccessToken() throws {
        accessToken = nil
    }
    
    func removeRefreshToken() throws {
        refreshToken = nil
    }
}
