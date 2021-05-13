//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 09.05.21.
//

import Combine

internal extension Publisher where Output == TokenDataProviding {
    
    func storeTokenData(_ tokenStore: TokenStoring) -> AnyPublisher<TokenDataProviding, Error> {
        tryMap { data in
            try tokenStore.storeToken(data.access)
            try tokenStore.storeToken(data.refresh)
            return data
        }
        .eraseToAnyPublisher()
    }
    
}
