//
// Introductory information can be found in the `README.md` file located at the root of the repository that contains this file.
// Licensing information can be found in the `LICENSE` file located at the root of the repository that contains this file.
//

import Foundation
import Combine

public extension NetworkManager {
    func download(
        request: URLRequest,
        retryCount: Int = .zero,
        needsAuthorization: Bool = true
    ) -> AnyPublisher<URL, URLError> {
        if needsAuthorization, let authorizer = authorizer {
            return authorizer.authorize(request)
                .mapError { _ in URLError(.userAuthenticationRequired )}
                .flatMap { [weak self] authorizedRequest -> AnyPublisher<URL, URLError> in
                    return self?.download(
                        request: authorizedRequest,
                        retryCount: retryCount
                    )
                    ?? PassthroughSubject<URL, URLError>().eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        } else {
            return download(request: request, retryCount: retryCount)
        }
    }
    
    private func download(
        request: URLRequest,
        retryCount: Int = .zero
    ) -> AnyPublisher<URL, URLError> {
        return session.downloadTask(for: request)
            .retry(retryCount)
            .map(\.url)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
