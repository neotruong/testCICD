//
//  AuthDataTest.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/4/24.
//

import Foundation
import XCTest
@testable import NimbleCodeChallenge

class AuthDataTests: XCTestCase {

    func testAuthDataInitialization() {
        let accessToken = "validAccessToken"
        let refreshToken = "validRefreshToken"
        let expiresIn = 3600
        let createdAt = Int(Date().timeIntervalSince1970)


        let authData = AuthData(accessToken: accessToken, refreshToken: refreshToken, expiresIn: expiresIn, createdAt: createdAt)

        XCTAssertEqual(authData.accessToken, accessToken, "Access token should match the input")
        XCTAssertEqual(authData.refreshToken, refreshToken, "Refresh token should match the input")
        XCTAssertEqual(authData.expiresIn, expiresIn, "ExpiresIn should match the input")
        XCTAssertEqual(authData.createdAt, createdAt, "CreatedAt should match the input")
    }
}
