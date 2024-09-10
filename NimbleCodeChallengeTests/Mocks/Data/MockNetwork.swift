//
//  MockNetwork.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/7/24.
//

import Foundation
import Combine
import Alamofire

@testable import NimbleCodeChallenge


class MockNetworkRepository: NetworkRepositoryProtocol {

    var mockRequestResult: Any?
    var mockRefreshTokenResult: Result<AuthResponseDTO, NetworkError>?

    func request<T: BaseDTO>(_ url: String,
                               method: HTTPMethod = .get,
                               parameters: Parameters? = nil,
                               completion: @escaping (Result<T, NetworkError>) -> Void) {
        if let result = mockRequestResult as? Result<T, NetworkError> {
            completion(result)
        } else {
            completion(.failure(.unknownError))
        }
    }

    func refreshToken(url: String,
                      method: HTTPMethod,
                      parameters: Parameters?,
                      completion: @escaping (Result<AuthResponseDTO, NetworkError>) -> Void) {
        if let result = mockRefreshTokenResult {
            completion(result)
        } else {
            completion(.failure(.unknownError))
        }
    }

    func trackProgress(for url: String) -> Progress? {
        return nil
    }
}
