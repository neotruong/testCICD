//
//  MockAuthRepo.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/4/24.
//

import Foundation
import Combine
@testable import NimbleCodeChallenge

class MockAuthRepo: AuthRepoInterface {
    
    func refreshToken(request: NimbleCodeChallenge.AuthRefreshTokenDTO) -> AnyPublisher<Result<NimbleCodeChallenge.AuthResponseDTO, NimbleCodeChallenge.NetworkError>, Never> {
        return Just(result ?? .failure(NetworkError.unknownError))
            .eraseToAnyPublisher()
    }
    
    var result: Result<AuthResponseDTO, NetworkError>?

    func loginWithEmailOrToken(request: AuthRequestDTO) -> AnyPublisher<Result<AuthResponseDTO, NetworkError>, Never> {
        return Just(result ?? .failure(NetworkError.unknownError))
            .eraseToAnyPublisher()
    }
}
