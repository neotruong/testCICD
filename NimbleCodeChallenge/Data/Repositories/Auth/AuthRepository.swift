//
//  AuthRepository.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/1/24.
//

import Foundation
import Combine

final class AuthRepository: AuthRepoInterface {

    let network: NetworkRepositoryProtocol
    var userSession: UserSessionRepoInterface?

    init(network: NetworkRepositoryProtocol = NetworkManager.shared()) {
        self.network = network
    }

    func loginWithEmailOrToken(request: AuthRequestDTO) -> AnyPublisher<Result<AuthResponseDTO, NetworkError>, Never> {
        let endpoint = EndpointsManager.shared.getEndPoints(for: AuthEndpoint(), type: .login)

        return Future { promise in
            self.network.request(endpoint,
                                 method: .post,
                                 parameters: request.toDictionary()) { [weak self] (result: Result<AuthResponseDTO, NetworkError>) in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.storeUserData(data: response)
                case .failure(let failure):
                    break
                }
                promise(.success(result))
            }
        }
        .eraseToAnyPublisher()
    }

    private func storeUserData(data: AuthResponseDTO) {
        guard let userSession = userSession else {
            return
        }
        let storedData = UserSessionData(accessToken: data.data.attributes.accessToken,
                                         refreshToken: data.data.attributes.refreshToken,
                                         expiresIn: data.data.attributes.expiresIn,
                                         createdAt: data.data.attributes.createdAt)

        userSession.storeUserSession(data: storedData)
    }

    func refreshToken(request: AuthRefreshTokenDTO) -> AnyPublisher<Result<AuthResponseDTO, NetworkError>, Never> {
        let endpoint = EndpointsManager.shared.getEndPoints(for: AuthEndpoint(), type: .login)

        return Future { promise in
            self.network.refreshToken(url: endpoint,
                                      method: .post,
                                      parameters: request.toDictionary()) { (result: Result<AuthResponseDTO, NetworkError>) in
                promise(.success(result))
            }
        }
        .eraseToAnyPublisher()
    }
}
