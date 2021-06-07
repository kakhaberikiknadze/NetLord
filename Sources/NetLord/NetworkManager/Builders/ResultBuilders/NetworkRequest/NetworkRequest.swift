//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 25.05.21.
//

#if swift(>=5.4)
import Foundation
import Combine

public class NetworkRequest<Response: Decodable> {
    
    // MARK: - Private Properties
    private let manager: NetworkManaging
    private let builder: RequestBuilding
    private var onSuccess: ((Response) -> Void)?
    private var onError: ((Error) -> Void)?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    public init(
        manager: NetworkManaging,
        @NetworkRequestBuilder _ block: () -> RequestBuilding
    ) {
        self.manager = manager
        self.builder = block()
    }
    
    private func modify(_ block: (inout Self) -> Void) -> Self {
        var mutableSelf = self
        block(&mutableSelf)
        return mutableSelf
    }
    
    public func onSuccess(_ block: @escaping (Response) -> Void) -> Self {
        modify { $0.onSuccess = block }
    }
    
    public func onError(_ block: @escaping (Error) -> Void) -> Self {
        modify { $0.onError = block }
    }
    
    public func build() -> URLRequest {
        var request = URLRequest(url: URL(string: "https://")!)
        builder.buildRequest(&request)
        return request
    }
    
    public func performPublisher() -> AnyPublisher<Response, Error> {
        var request = URLRequest(url: URL(string: "https://")!)
        builder.buildRequest(&request)
        return manager.perform(request: request)
    }
    
    public func perform() {
        var request = URLRequest(url: URL(string: "https://")!)
        builder.buildRequest(&request)
        let cancellable: AnyPublisher<Response, Error> = manager.perform(request: request)
        cancellable
            .sink { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.onError?(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] value in
                self?.onSuccess?(value)
            }
            .store(in: &cancellables)
    }
    
}
#endif
