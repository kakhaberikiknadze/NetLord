//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 09.05.21.
//

import Combine

internal extension Publisher where Output == Tokenable {
    
    func storeAccessToken(_ tokenStore: TokenStoring) -> AnyPublisher<Tokenable, Error> {
        tryMap { token in
            try tokenStore.storeAccessToken(token)
            return token
        }
        .eraseToAnyPublisher()
    }
    
    func storeRefreshToken(_ tokenStore: TokenStoring) -> AnyPublisher<Tokenable, Error> {
        tryMap { token in
            try tokenStore.storeRefreshToken(token)
            return token
        }
        .eraseToAnyPublisher()
    }
    
}
