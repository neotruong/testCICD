//
//  TokenManager.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/3/24.
//

import Foundation
import Combine

protocol UserSessionProtocol {
    func getAccessToken() -> String?
    func clearSession()
    func isTokenExpired() -> Bool
    func isLogin() -> Bool
}

struct UserSessionData {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let createdAt: Int
}

class UserSession: UserSessionProtocol {

    let userSessionRepo: UserSessionRepoInterface
    let onRefershTokenError: PassthroughSubject<Error, Never> = .init()

    init(userSessionRepo: UserSessionRepo) {
        self.userSessionRepo = userSessionRepo
    }

    func getAccessToken() -> String? {
        return userSessionRepo.getAccessToken()
    }

    func storeUserSession(data: UserSessionData) {
        userSessionRepo.storeUserSession(data: data)
    }

    func clearSession() {
        userSessionRepo.clearSession()
    }

    func isTokenExpired() -> Bool {
        return userSessionRepo.isTokenExpired()
    }

    func isLogin() -> Bool {
        return userSessionRepo.isLogin()
    }

}
