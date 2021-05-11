//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 09.05.21.
//

public protocol TokenDataProviding {
    var access: Token { get }
    var refresh: Token { get }
}
