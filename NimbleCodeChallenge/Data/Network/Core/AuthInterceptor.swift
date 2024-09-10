//
//  AuthInterceptor.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/7/24.
//

import Foundation
import Alamofire
import Combine

class AuthInterceptor: RequestInterceptor {
    let retryLimit = 2
    var retryCount = 0
    var userSession: UserSessionRepoInterface
    private let unAuthenCode = 401
    private var cancelBag = Set<AnyCancellable>()

    init(userSession: UserSessionRepoInterface) {
        self.userSession = userSession
    }

    func adapt(_ urlRequest: URLRequest, 
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        if let token = userSession.getAccessToken(), !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }

    func retry(_ request: Request, 
               for session: Session,
               dueTo error: Error, 
               completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }

        if request.retryCount < retryLimit {
            userSession.refreshToken()
                .sink(receiveValue: { result in
                    switch result {
                    case .success:
                        completion(.retry)
                    case .failure:
                        completion(.doNotRetry)
                    }
                })
                .store(in: &cancelBag)
        } else {
            completion(.doNotRetry)
        }
    }
}
