//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 10.05.21.
//

public protocol TokenStoring {
    func storeToken(_ token: Token)
    func getAccessToken() -> Token?
    func getRefreshToken() -> Token?
    func removeAccessToken()
    func removeRefreshToken()
}
