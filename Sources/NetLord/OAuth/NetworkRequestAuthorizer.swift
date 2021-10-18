//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 09.05.21.
//

import Foundation
import Combine

public protocol TokenRefreshing {
    func refreshAccessToken(using refreshToken: String) -> AnyPublisher<Tokenable, Error>
}

public final class NetworkRequestAuthorizer {
    public typealias TokenRefreshHandler = (String) -> AnyPublisher<Tokenable, Error>
    
    internal let tokenStore: TokenStoring
    internal let configuration: Configuration
    internal let tokenRefreshBlock: TokenRefreshHandler?
    internal let tokenRefresher: TokenRefreshing?
    
    public init(
        tokenStore: TokenStoring,
        configuration: Configuration = .default,
        onTokenRefreshRequest refreshBlock: TokenRefreshHandler?
    ) {
        self.tokenStore = tokenStore
        self.configuration = configuration
        tokenRefreshBlock = refreshBlock
        tokenRefresher = nil
    }
    
    public init(
        tokenStore: TokenStoring,
        configuration: Configuration = .default,
        tokenRefresher: TokenRefreshing?
    ) {
        self.tokenStore = tokenStore
        self.configuration = configuration
        self.tokenRefresher = tokenRefresher
        tokenRefreshBlock = nil
    }
}

// MARK: - Refresh Token
// TODO: - Add tests for NetworkRequestAuthorizer

private extension NetworkRequestAuthorizer {
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
            return refreshTokenIfAvailable()
        }
        return CurrentValueSubject<Tokenable, OAuthError>(accessToken).eraseToAnyPublisher()
    }
    
    func refreshTokenIfAvailable() -> AnyPublisher<Tokenable, OAuthError> {
        if let refreshToken = tokenStore.getRefreshToken(), refreshToken.isValid {
            return refreshAccessToken(with: refreshToken.value)
                .storeAccessToken(tokenStore)
                .mapError { OAuthError.tokenRefreshFailed($0) }
                .eraseToAnyPublisher()
        } else {
            return Fail(error: OAuthError.refreshTokenNotFound).eraseToAnyPublisher()
        }
    }
    
    func refreshAccessToken(with refreshToken: String) -> AnyPublisher<Tokenable, Error> {
        if let refresher = tokenRefresher {
            return refresher.refreshAccessToken(using: refreshToken)
        } else if let closure = tokenRefreshBlock {
            return closure(refreshToken)
        } else {
            return Fail(error: OAuthError.tokenRefresherNotFound).eraseToAnyPublisher()
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
