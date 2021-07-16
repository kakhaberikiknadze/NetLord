//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 09.05.21.
//

import Foundation

public extension NetworkRequestAuthorizer {
    struct Configuration {
        public let tokenRefreshTimeInterval: TimeInterval
    }
}

public extension NetworkRequestAuthorizer.Configuration {
    static let `default`: NetworkRequestAuthorizer.Configuration = .init(tokenRefreshTimeInterval: 300)
}
