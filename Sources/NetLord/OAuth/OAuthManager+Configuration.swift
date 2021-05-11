//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 09.05.21.
//

public extension OAuthManager {
    
    struct Configuration {
        let tokenRefreshTimeInterval: Double
    }
    
}

public extension OAuthManager.Configuration {
    
    static let `default`: OAuthManager.Configuration = .init(tokenRefreshTimeInterval: 300)
    
}
