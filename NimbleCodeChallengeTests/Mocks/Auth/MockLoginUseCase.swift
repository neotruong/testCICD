//
//  MockAuthUseCase.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/4/24.
//
import Combine
import Foundation
@testable import NimbleCodeChallenge

class MockLoginUseCase: LoginUseCaseProtocol {

    var result: Result<AuthData, NetworkError>?

    func mappingDTO(_ dtoData: NimbleCodeChallenge.AuthResponseDTO) -> NimbleCodeChallenge.AuthData {
        return AuthData(accessToken: "", refreshToken: "", expiresIn: 0, createdAt: 0)
    }

    var validateEmailResult = true
    var validatePasswordResult = true
    var loginWithPasswordResult: Result<AuthData, NetworkError> = .failure(.customError("Login failed"))

    func validateEmail(email: String) -> Bool {
        return validateEmailResult
    }

    func validatePassword(password: String) -> Bool {
        return validatePasswordResult
    }

    func loginWithPassword(email: String, password: String) -> AnyPublisher<Result<AuthData, NetworkError>, Never> {
        return Just(result!)
            .eraseToAnyPublisher()
    }
}
