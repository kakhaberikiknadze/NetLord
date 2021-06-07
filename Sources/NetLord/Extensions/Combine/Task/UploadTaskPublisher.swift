//
// Introductory information can be found in the `README.md` file located at the root of the repository that contains this file.
// Licensing information can be found in the `LICENSE` file located at the root of the repository that contains this file.
//

import Foundation
import Combine

public typealias UploadTaskOutput = (data: Data?, response: URLResponse)

internal extension URLSession {
    
    func uploadTaskPublisher(
        for request: URLRequest,
        with bodyData: Data?
    ) -> URLSession.UploadTaskPublisher {
        .init(request: request, session: self, bodyData: bodyData)
    }
    
    struct UploadTaskPublisher: Publisher {
        
        internal typealias Output = UploadTaskOutput
        internal typealias Failure = Error
        
        internal let request: URLRequest
        internal let session: URLSession
        internal let bodyData: Data?
        
        internal init(request: URLRequest, session: URLSession, bodyData: Data?) {
            self.request = request
            self.session = session
            self.bodyData = bodyData
        }
        
        func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
            let subscription = UploadTaskSubscription(subscriber: subscriber,
                                                      session: session,
                                                      request: request,
                                                      bodyData: bodyData)
            subscriber.receive(subscription: subscription)
        }
        
    }
    
}

internal extension URLSession {
    
    final class UploadTaskSubscription<S: Subscriber>: Subscription where
        S.Input == UploadTaskOutput,
        S.Failure == Error
    {
        private let subscriber: S?
        private weak var session: URLSession?
        private let request: URLRequest
        private let bodyData: Data?
        private var task: URLSessionUploadTask?
        
        init(subscriber: S, session: URLSession, request: URLRequest, bodyData: Data?) {
            self.subscriber = subscriber
            self.request = request
            self.session = session
            self.bodyData = bodyData
        }
        
        func request(_ demand: Subscribers.Demand) {
            guard let session = session, demand > .zero else { return }
            task = session.uploadTask(with: request, from: bodyData, completionHandler: { [weak self] data, response, error in
                if let error = error {
                    self?.subscriber?.receive(completion: .failure(error))
                }
                guard let response = response else {
                    self?.subscriber?.receive(completion: .failure(URLError(.badServerResponse)))
                    return
                }
                _ = self?.subscriber?.receive((data, response))
                self?.subscriber?.receive(completion: .finished)
            })
            task!.resume()
        }
        
        func cancel() {
            task?.cancel()
        }
    }
    
}

internal final class UploadTaskSubscriber: Subscriber {
    
    internal typealias Input = UploadTaskOutput
    internal typealias Failure = Error
    
    internal var subscription: Subscription?
    
    internal func receive(subscription: Subscription) {
        self.subscription = subscription
        self.subscription?.request(.max(1))
    }
    
    internal func receive(_ input: Input) -> Subscribers.Demand {
        print("Subscriber value \(String(describing: input.data))")
        return .none
    }
    
    internal func receive(completion: Subscribers.Completion<Error>) {
        print("Subscriber completion \(completion)")
        self.subscription?.cancel()
        self.subscription = nil
    }
    
}
