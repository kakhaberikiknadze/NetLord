//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 09.05.21.
//

import Combine
import Foundation

public protocol Authorizing: AnyObject {
    var isSignedIn: Bool { get }
    func authorize() -> AnyPublisher<HTTPHeaders, Error>
}
