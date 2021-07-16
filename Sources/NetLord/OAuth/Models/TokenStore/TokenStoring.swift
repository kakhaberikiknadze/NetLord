//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 10.05.21.
//

public protocol TokenStoring {
    func storeAccessToken(_ token: Tokenable) throws
    func storeRefreshToken(_ token: Tokenable) throws
    func getAccessToken() -> Tokenable?
    func getRefreshToken() -> Tokenable?
    func removeAccessToken() throws
    func removeRefreshToken() throws
}
