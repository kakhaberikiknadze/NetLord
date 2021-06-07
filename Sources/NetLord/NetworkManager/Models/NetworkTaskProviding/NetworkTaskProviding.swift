//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 07.06.21.
//

import Foundation
import Combine

public protocol NetworkTaskProviding {
    func dataTask(for request: URLRequest) -> AnyPublisher<DataTaskOutput, URLError>
    func downloadTask(for request: URLRequest) -> AnyPublisher<DownloadTaskOutput, URLError>
    func uploadTask(for request: URLRequest, with bodyData: Data?) -> AnyPublisher<UploadTaskOutput, Error>
}
