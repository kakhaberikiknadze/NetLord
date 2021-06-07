//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 07.06.21.
//

import Foundation
import Combine
@testable import NetLord

class MockSession: NetworkTaskProviding {
    
    var data: Data?
    var response: URLResponse?
    var error: URLError?
    var url: URL?
    
    init(
        data: Data? = nil,
        response: URLResponse? = nil,
        error: URLError? = nil
    ) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    init(
        url: URL? = nil,
        response: URLResponse? = nil,
        error: URLError? = nil
    ) {
        self.url = url
        self.response = response
        self.error = error
    }
    
    func dataTask(for request: URLRequest) -> AnyPublisher<DataTaskOutput, URLError> {
        if let data = data {
            return Just<DataTaskOutput>((data, response ?? URLResponse()))
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        } else if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            return Fail(error: URLError(.unknown)).eraseToAnyPublisher()
        }
    }
    
    func downloadTask(for request: URLRequest) -> AnyPublisher<DownloadTaskOutput, URLError> {
        if let url = url {
            return Just<DownloadTaskOutput>((url, response ?? URLResponse()))
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        } else if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            return Fail(error: URLError(.unknown)).eraseToAnyPublisher()
        }
    }
    
    func uploadTask(for request: URLRequest, with bodyData: Data?) -> AnyPublisher<UploadTaskOutput, Error> {
        if let data = data {
            return Just<UploadTaskOutput>((data, response ?? URLResponse()))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "data and error are nil", code: -1, userInfo: nil))
                .eraseToAnyPublisher()
        }
    }
    
}
