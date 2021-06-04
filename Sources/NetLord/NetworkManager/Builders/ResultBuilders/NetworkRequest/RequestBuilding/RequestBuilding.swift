//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 25.05.21.
//

#if swift(>=5.4)
import Foundation

public protocol RequestBuilding {
    func buildRequest(_ request: inout URLRequest)
}
#endif
