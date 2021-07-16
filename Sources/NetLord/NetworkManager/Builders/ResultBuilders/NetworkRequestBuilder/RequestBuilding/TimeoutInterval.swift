//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 25.05.21.
//

#if swift(>=5.4)
import Foundation

public struct TimeoutInterval: RequestBuilding {
    private let interval: TimeInterval
    
    public init(_ interval: TimeInterval) {
        self.interval = interval
    }
    
    public func buildRequest(_ request: inout URLRequest) {
        request.timeoutInterval = interval
    }
}
#endif
