//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 07.06.21.
//

import Foundation
import Combine

extension URLSession: NetworkTaskProviding {
    public func uploadTask(for request: URLRequest, with bodyData: Data?) -> AnyPublisher<UploadTaskOutput, Error> {
        uploadTaskPublisher(for: request, with: bodyData).eraseToAnyPublisher()
    }
    
    public func downloadTask(for request: URLRequest) -> AnyPublisher<DownloadTaskOutput, URLError> {
        downloadTaskPublisher(for: request).eraseToAnyPublisher()
    }
    
    public func dataTask(for request: URLRequest) -> AnyPublisher<DataTaskOutput, URLError> {
        dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}
