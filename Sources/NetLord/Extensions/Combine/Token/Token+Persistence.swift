//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 09.05.21.
//

import Combine

internal extension Publisher where Output == Token {
    
    func storeToken(_ tokenStore: TokenStoring) -> AnyPublisher<Token, Error> {
        tryMap { token in
            try tokenStore.storeToken(token)
            return token
        }
        .eraseToAnyPublisher()
    }
    
}
