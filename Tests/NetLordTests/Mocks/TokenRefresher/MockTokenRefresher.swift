//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 19.10.21.
//

import Foundation
import Combine
@testable import NetLord

struct MockTokenRefresher: TokenRefreshing {
    var refreshedAccessToken: Tokenable
    
    func refreshAccessToken(using refreshToken: RefreshToken) -> AnyPublisher<Tokenable, Error> {
        Just(refreshedAccessToken)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
