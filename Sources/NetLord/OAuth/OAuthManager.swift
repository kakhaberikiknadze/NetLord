//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 09.05.21.
//

import Foundation
import Combine

public final class OAuthManager {
    
    internal let service: OAuthService
    internal let tokenStore: TokenStoring
    internal let configuration: Configuration
    
    public init(
        service: OAuthService,
        tokenStore: TokenStoring,
        configuration: Configuration = .default
    ) {
        self.service = service
        self.tokenStore = tokenStore
        self.configuration = configuration
    }
    
}

public extension OAuthManager {
    
    func shouldRefreshToken(_ accessToken: Token) -> Bool {
        guard let expirationDate = accessToken.expireDate else {
            return false
        }
        return Date().addingTimeInterval(configuration.tokenRefreshTimeInterval) >= expirationDate
    }
    
}

// MARK: - Sign In Request
extension OAuthManager: SignInRequestProvider {
    
    public var signInRequest: URLRequest { service.signInRequest }
    
}

// MARK: - Retrieve Token
extension OAuthManager: TokenRetrieving {
    
    public func getAccessTokenFromRefreshToken(_ token: Token) -> AnyPublisher<Token, Error> {
        service.getAccessTokenFromRefreshToken(token)
            .storeToken(tokenStore)
            .eraseToAnyPublisher()
    }
    
    public func getTokenDataFromCode(_ code: String) -> AnyPublisher<TokenDataProviding, Error> {
        service.getTokenDataFromCode(code)
            .storeTokenData(tokenStore)
            .eraseToAnyPublisher()
    }
    
}

// MARK: - Refresh Token
extension OAuthManager {
    
    public func refreshTokenIfAvailable() -> AnyPublisher<Token, OAuthError> {
        if let refreshToken = tokenStore.getToken(ofType: .refresh), refreshToken.isValid {
            return getAccessTokenFromRefreshToken(refreshToken)
                .mapError { error in
                    OAuthError.tokenRefreshFailed
                }
                .eraseToAnyPublisher()
        } else {
            return Fail(error: OAuthError.refreshTokenNotFound).eraseToAnyPublisher()
        }
    }
    
}

// MARK: - Authorize
extension OAuthManager {
    
    public func authorize() -> AnyPublisher<Token, OAuthError> {
        guard let accessToken = tokenStore.getToken(ofType: .access),
              !shouldRefreshToken(accessToken)
        else {
            return refreshTokenIfAvailable()
        }
        return CurrentValueSubject<Token, OAuthError>(accessToken).eraseToAnyPublisher()
    }
    
}

extension OAuthManager: Authorizing {
    
    public var isSignedIn: Bool {
        guard let refreshToken = tokenStore.getToken(ofType: .refresh) else {
            return false
        }
        return refreshToken.isValid
    }
    
    public func authorize() -> AnyPublisher<HTTPHeaders, Error> {
        authorize()
            .map { ["Authorization": "Bearer " + $0.value] }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
}
