//
//  LoginUseCase.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 8/31/24.
//

import Foundation
import Combine

protocol LoginUseCaseProtocol {
    func validateEmail(email: String) -> Bool
    func validatePassword(password: String) -> Bool
    func loginWithPassword(email: String, password: String) -> AnyPublisher<Result<AuthData, NetworkError>, Never>
    func mappingDTO(_ dtoData: AuthResponseDTO) -> AuthData
}

final class LoginUseCase: LoginUseCaseProtocol {

    private let authRepo: AuthRepoInterface
    let clientId: String = ConfigHelper.clientId
    let clientSecret: String = ConfigHelper.clientSecret
    
    init(authRepo: AuthRepoInterface) {
        self.authRepo = authRepo
    }
    
    func loginWithPassword(email: String, password: String) -> AnyPublisher<Result<AuthData, NetworkError>, Never> {
        let authRequest = AuthRequestDTO(grantType: .password, 
                                         email: email,
                                         password: password, 
                                         clientId: clientId,
                                         clientSecret: clientSecret)

        return authRepo.loginWithEmailOrToken(request: authRequest)
            .map { result in
                result.map { self.mappingDTO($0) }
            }
            .eraseToAnyPublisher()
    }
    
    func mappingDTO(_ dtoData: AuthResponseDTO) -> AuthData {
        let acessToken = dtoData.data.attributes.accessToken
        let refreshToken = dtoData.data.attributes.refreshToken
        return AuthData(accessToken: acessToken, refreshToken: refreshToken, 
                        expiresIn: dtoData.data.attributes.expiresIn,
                        createdAt: dtoData.data.attributes.createdAt)
    }
    
    func validateEmail(email: String) -> Bool {
        return !email.isEmpty
    }
    
    func validatePassword(password: String) -> Bool {
        return !password.isEmpty
    }
    
}
