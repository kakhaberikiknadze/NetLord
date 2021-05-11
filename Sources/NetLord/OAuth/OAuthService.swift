//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 09.05.21.
//

import Foundation
import Combine

public protocol SignInRequestProvider {
    var signInRequest: URLRequest { get }
}

public protocol TokenRetrieving {
    func getTokenDataFromCode(_ code: String) -> AnyPublisher<TokenDataProviding, Error>
    func getAccessTokenFromRefreshToken(_ refreshToken: Token) -> AnyPublisher<Token, Error>
}

public typealias OAuthService = SignInRequestProvider & TokenRetrieving
