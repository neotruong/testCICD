//
//  UserSessionRepo.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/10/24.
//

import Foundation
import Combine

protocol UserSessionRepoInterface {
    func storeUserSession(data: UserSessionData)

    func isTokenExpired() -> Bool
    func isLogin() -> Bool
    func getAccessToken() -> String?
    func clearSession()
    func refreshToken() -> AnyPublisher<Result<String, NetworkError>, Never>
}

class UserSessionRepo: UserSessionRepoInterface {

    private let keychain: KeyChainProtocol
    let authRepo: AuthRepoInterface

    init(keychain: KeyChainProtocol, authRepo: AuthRepoInterface) {
        self.keychain = keychain
        self.authRepo = authRepo
    }

    func isLogin() -> Bool {
        return !keychain.getData(key: .accessToken).isEmpty
    }

    func getAccessToken() -> String? {
        return keychain.getData(key: .accessToken)
    }

    func getRefreshToken() -> String? {
        return keychain.getData(key: .refreshToken)
    }

    func storeUserSession(data: UserSessionData) {
        keychain.storeData(keyValue: (KeyChainType.refreshToken, data.refreshToken))
        keychain.storeData(keyValue: (KeyChainType.accessToken, data.accessToken))
        keychain.storeData(keyValue: (KeyChainType.createdAt, data.createdAt))
        keychain.storeData(keyValue: (KeyChainType.expiresIn, data.expiresIn))
    }

    func refreshToken() -> AnyPublisher<Result<String, NetworkError>, Never> {
            let clientId: String = ConfigHelper.clientId
            let clientSecret: String = ConfigHelper.clientSecret

            return authRepo.refreshToken(request: AuthRefreshTokenDTO(grantType: .refreshToken,
                                                                      clientId: clientId,
                                                                      clientSecret: clientSecret))
            .map { response -> Result<String, NetworkError> in
                switch response {
                case .success(let authResponseDTO):

                    let accessToken = authResponseDTO.data.attributes.accessToken
                    let refreshToken = authResponseDTO.data.attributes.refreshToken
                    let expriseIn = authResponseDTO.data.attributes.expiresIn
                    let createdAt = authResponseDTO.data.attributes.createdAt

                    let authData = UserSessionData(accessToken: accessToken,
                                            refreshToken: refreshToken,
                                            expiresIn: expriseIn,
                                            createdAt: createdAt)

                    self.storeUserSession(data: authData)

                    return .success(accessToken)
                case .failure(let error):
                    return .failure(.customError(error.localizedDescription))
                }
            }
            .eraseToAnyPublisher()
        }

    func isTokenExpired() -> Bool {
        guard let createdAt = Int(keychain.getData(key: .createdAt)),
              let expiresIn = Int(keychain.getData(key: .expiresIn)) else {
            return true
        }

        let creationDate = Date(timeIntervalSince1970: TimeInterval(createdAt))
        let expirationDate = creationDate.addingTimeInterval(TimeInterval(expiresIn))

        return Date() > expirationDate
    }

    func clearSession() {
        keychain.clearAllKeys()
    }

}
