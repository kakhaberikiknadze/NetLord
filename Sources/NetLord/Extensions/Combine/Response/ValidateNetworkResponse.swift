//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 08.03.21.
//

import Foundation
import Combine

public typealias DataTaskOutput = (data: Data, response: URLResponse)

internal extension Publisher where Output == DataTaskOutput {
    func validateNetworkResponse() -> AnyPublisher<Data, Error> {
        tryMap({ data, resposne in
            guard let httpResponse = resposne as? HTTPURLResponse else { return data }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw URLError(URLError.Code(rawValue: httpResponse.statusCode))
            }
            return data
        })
        .eraseToAnyPublisher()
    }
}
