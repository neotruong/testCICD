//
//  AuthRepo.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/2/24.
//

import Foundation
import Combine

protocol AuthRepoInterface {
    func refreshToken(request: AuthRefreshTokenDTO) -> AnyPublisher<Result<AuthResponseDTO, NetworkError>, Never>
    func loginWithEmailOrToken(request: AuthRequestDTO) -> AnyPublisher<Result<AuthResponseDTO, NetworkError>, Never>
}
