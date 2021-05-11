//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 10.05.21.
//

import Foundation

public enum OAuthError: Error {
    case unknown(Error)
    case refreshTokenNotFound
    case refreshTokenExpired
    case accessTokenNotFound
    case accessTokenExpired
    case tokenRefreshFailed
}
