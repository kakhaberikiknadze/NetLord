//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 09.05.21.
//

import Foundation
import Combine

public typealias AccessToken = String
public typealias RefreshToken = String

public protocol TokenRefreshing {
    func refreshAccessToken(using refreshToken: RefreshToken) -> AnyPublisher<Tokenable, Error>
}

public final class NetworkRequestAuthorizer {
    public typealias TokenRefreshHandler = (RefreshToken) -> AnyPublisher<Tokenable, Error>
    
    internal let tokenStore: TokenStoring
    internal let configuration: Configuration
    internal let tokenRefreshBlock: TokenRefreshHandler
    
    public init(
        tokenStore: TokenStoring,
        configuration: Configuration = .default,
        onTokenRefreshRequest refreshBlock: @escaping TokenRefreshHandler
    ) {
        self.tokenStore = tokenStore
        self.configuration = configuration
        tokenRefreshBlock = refreshBlock
    }
    
    public init(
        tokenStore: TokenStoring,
        configuration: Configuration = .default,
        tokenRefresher: TokenRefreshing
    ) {
        self.tokenStore = tokenStore
        self.configuration = configuration
        tokenRefreshBlock = tokenRefresher.refreshAccessToken
    }
}

// MARK: - Refresh Token
// TODO: - Add tests for NetworkRequestAuthorizer

extension NetworkRequestAuthorizer {
    func shouldRefreshToken(_ accessToken: Tokenable) -> Bool {
        guard let expirationDate = accessToken.expireDate else {
            return false
        }
        return Date().addingTimeInterval(configuration.tokenRefreshTimeInterval) >= expirationDate
    }
    
    func authorizeAccessToken() -> AnyPublisher<Tokenable, OAuthError> {
        guard let accessToken = tokenStore.getAccessToken(),
              !shouldRefreshToken(accessToken)
        else {
            return refreshToken()
        }
        return CurrentValueSubject<Tokenable, OAuthError>(accessToken).eraseToAnyPublisher()
    }
    
    func refreshToken() -> AnyPublisher<Tokenable, OAuthError> {
        if let refreshToken = tokenStore.getRefreshToken(), refreshToken.isValid {
            return tokenRefreshBlock(refreshToken.value)
                .storeAccessToken(tokenStore)
                .mapError { OAuthError.tokenRefreshFailed($0) }
                .eraseToAnyPublisher()
        } else {
            return Fail(error: OAuthError.refreshTokenNotFound).eraseToAnyPublisher()
        }
    }
}

// MARK: - Authorizing

extension NetworkRequestAuthorizer: Authorizing {
    public var isSignedIn: Bool {
        guard let refreshToken = tokenStore.getRefreshToken() else {
            return false
        }
        return refreshToken.isValid
    }
    
    public func authorize(_ request: URLRequest) -> AnyPublisher<URLRequest, Error> {
        authorizeAccessToken()
            .map { ["Authorization": "Bearer " + $0.value] }
            .map { headers in
                var newRequest = request
                headers.forEach { newRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
                return newRequest
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
