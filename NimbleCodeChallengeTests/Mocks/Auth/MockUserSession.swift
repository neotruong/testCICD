//
//  MockUserSession.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/4/24.
//

import Combine
@testable import NimbleCodeChallenge

class MockUserSession: UserSessionProtocol {
    var ensureValidTokenResult: Result<String, NetworkError>?
    
    func getAccessToken() -> String? {
        return ""
    }

    func clearSession() {

    }

    func isTokenExpired() -> Bool {
        return true
    }

    func isLogin() -> Bool {
        return true
    }

    var storedAuthData: AuthData?

    func storeUserSession(data: AuthData) {
        storedAuthData = data
    }

    func ensureValidToken() -> AnyPublisher<Result<String, NetworkError>, Never> {
        guard let result = ensureValidTokenResult else {
            return Just(.failure(.unknownError)).eraseToAnyPublisher()
        }
        return Just(result).eraseToAnyPublisher()
    }
}
