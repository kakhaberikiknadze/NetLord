//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 25.05.21.
//

#if swift(>=5.4)
import Foundation

extension Array: RequestBuilding where Element == RequestBuilding {
    
    public func buildRequest(_ request: inout URLRequest) {
        forEach { $0.buildRequest(&request) }
    }
    
}
#endif
