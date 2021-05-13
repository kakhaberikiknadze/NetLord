//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 10.05.21.
//

public protocol TokenStoring {
    func storeToken(_ token: Token) throws
    func getToken(ofType tokenType: TokenType) -> Token?
    func removeToken(ofType tokenType: TokenType) throws
}
