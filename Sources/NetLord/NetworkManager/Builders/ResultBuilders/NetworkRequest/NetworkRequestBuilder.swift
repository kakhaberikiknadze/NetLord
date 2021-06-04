//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 25.05.21.
//

#if swift(>=5.4)
import Foundation

@resultBuilder
public struct NetworkRequestBuilder {
    
    static func buildBlock(_ components: RequestBuilding...) -> RequestBuilding {
        components
    }
    
    static func buildBlock(_ component: RequestBuilding) -> RequestBuilding {
        component
    }
    
    public static func buildIf(_ param: RequestBuilding?) -> RequestBuilding {
        param ?? Array<RequestBuilding>()
    }
    
    public static func buildEither(first: RequestBuilding) -> RequestBuilding {
        first
    }
    
    public static func buildEither(second: RequestBuilding) -> RequestBuilding {
        second
    }
    
}
#endif
