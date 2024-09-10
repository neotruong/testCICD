//
//  OAuthManger.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/4/24.
//

import Combine
import Foundation

final class OAuthManager {
    static let shared = OAuthManager()

    private init() {}

    func ensureValidToken() -> AnyPublisher<String, NetworkError> {
        if UserSession.shared.isTokenExpired() {
            return refreshAccessToken()
        } else {
            return Just(UserSession.shared.getAccessToken() ?? "")
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
    }

    private func refreshAccessToken() -> AnyPublisher<String, NetworkError> {
        guard let refreshToken = UserSession.shared.getRefreshToken() else {
            return Fail(error: NetworkError.customError("No refresh token available"))
                .eraseToAnyPublisher()
        }

        let endpoint = EndpointsManager.shared.getEndPoints(for: AuthEndpoint(), type: .login)

        return Future<String, NetworkError> { promise in
            let network = NetworkManager.shared
          
            network.request(endpoint, method: .post, parameters: parameters) { (result: Result<AuthData, NetworkError>) in
                switch result {
                case .success(let authData):
                    UserSession.shared.storeUserSession(data: authData)
                    promise(.success(authData.accessToken))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
