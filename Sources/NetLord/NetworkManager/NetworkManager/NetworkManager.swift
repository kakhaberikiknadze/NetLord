//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 08.03.21.
//

import Foundation
import Combine

public typealias HTTPHeaders = [String: String]

public final class NetworkManager {
    private(set) var session: NetworkTaskProviding
    private(set) var decoder: JSONDecoder
    internal let authorizer: Authorizing?
    
    #if swift(>=5.4)
    internal var builtRequest: URLRequest?
    #endif
    
    var cancellables = Set<AnyCancellable>()
    
    public init(
        session: NetworkTaskProviding,
        authorizer: Authorizing? = nil,
        decoder: JSONDecoder = .init()
    ) {
        self.session = session
        self.authorizer = authorizer
        self.decoder = decoder
    }
    
    public func changeSession(with newSession: NetworkTaskProviding) {
        session = newSession
    }
}
