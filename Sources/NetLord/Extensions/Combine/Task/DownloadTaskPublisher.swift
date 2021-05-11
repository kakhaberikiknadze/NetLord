//
//  File.swift
//  
//
//  Created by Kakhi Kiknadze on 10.03.21.
//

import Foundation
import Combine

internal typealias DownloadTaskOutput = (url: URL, response: URLResponse)

internal extension URLSession {

    func downloadTaskPublisher(for url: URL) -> URLSession.DownloadTaskPublisher {
        self.downloadTaskPublisher(for: .init(url: url))
    }

    func downloadTaskPublisher(for request: URLRequest) -> URLSession.DownloadTaskPublisher {
        .init(request: request, session: self)
    }

    struct DownloadTaskPublisher: Publisher {

        internal typealias Output = DownloadTaskOutput
        internal typealias Failure = URLError

        internal let request: URLRequest
        internal let session: URLSession

        internal init(request: URLRequest, session: URLSession) {
            self.request = request
            self.session = session
        }

        internal func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
            let subscription = DownloadTaskSubscription(subscriber: subscriber,
                                                        session: session,
                                                        request: request)
            subscriber.receive(subscription: subscription)
        }
    }
}

internal extension URLSession {

    final class DownloadTaskSubscription<S: Subscriber>: Subscription where
        S.Input == DownloadTaskOutput,
        S.Failure == URLError
    {
        private let subscriber: S?
        private weak var session: URLSession?
        private let request: URLRequest
        private var task: URLSessionDownloadTask?

        init(subscriber: S, session: URLSession, request: URLRequest) {
            self.subscriber = subscriber
            self.session = session
            self.request = request
        }

        func request(_ demand: Subscribers.Demand) {
            guard let session = session, demand > .zero else { return }
            task = session.downloadTask(with: request) { [weak self] url, response, error in
                if let error = error as? URLError {
                    self?.subscriber?.receive(completion: .failure(error))
                    return
                }
                guard let response = response else {
                    self?.subscriber?.receive(completion: .failure(URLError(.badServerResponse)))
                    return
                }
                guard let url = url else {
                    self?.subscriber?.receive(completion: .failure(URLError(.badURL)))
                    return
                }
                guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                    self?.subscriber?.receive(completion: .failure(URLError(.fileDoesNotExist)))
                    return
                }
                let fileUrl = cacheDirectory.appendingPathComponent((UUID().uuidString))
                do {
                    try FileManager.default.moveItem(atPath: url.path, toPath: fileUrl.path)
                    _ = self?.subscriber?.receive((url: fileUrl, response: response))
                    self?.subscriber?.receive(completion: .finished)
                }
                catch {
                    self?.subscriber?.receive(completion: .failure(URLError(.cannotCreateFile)))
                }
            }
            task!.resume()
        }

        func cancel() {
            task?.cancel()
        }
    }
}

internal final class DownloadTaskSubscriber: Subscriber {
    
    internal typealias Input = DownloadTaskOutput
    internal typealias Failure = URLError

    internal var subscription: Subscription?

    internal func receive(subscription: Subscription) {
        self.subscription = subscription
        self.subscription?.request(.max(1))
    }

    internal func receive(_ input: Input) -> Subscribers.Demand {
        print("Subscriber value \(input.url)")
        return .none
    }

    internal func receive(completion: Subscribers.Completion<Failure>) {
        print("Subscriber completion \(completion)")
        self.subscription?.cancel()
        self.subscription = nil
    }
    
}
