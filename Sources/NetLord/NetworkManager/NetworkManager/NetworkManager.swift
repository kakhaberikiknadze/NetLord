//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 08.03.21.
//

import Foundation
import Combine

public typealias HTTPHeaders = [String: String]

public final class NetworkManager: NetworkManaging {
    
    private(set) var session: URLSession
    private(set) var decoder: JSONDecoder
    internal let authorizer: Authorizing?
    
    var cancellables = Set<AnyCancellable>()
    
    public init(
        session: URLSession,
        authorizer: Authorizing? = nil,
        decoder: JSONDecoder = .init()
    ) {
        self.session = session
        self.authorizer = authorizer
        self.decoder = decoder
    }
    
    public func changeSession(with newSession: URLSession) {
        session = newSession
    }
    
}
