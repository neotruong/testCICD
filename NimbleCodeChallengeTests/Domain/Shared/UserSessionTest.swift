//
//  UserSessionTest.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/4/24.
//

import XCTest
import Combine
@testable import NimbleCodeChallenge

final class UserSessionTests: XCTestCase {

    private var userSession: UserSession!
    private var mockAuthRepo: MockAuthRepo!
    private var cancelBag = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        mockAuthRepo = MockAuthRepo()
        userSession = UserSession(keychain: MockKeychainHelper(), authRepo: mockAuthRepo)
    }

    override func tearDown() {
        cancelBag = []
        super.tearDown()
    }

    func testEnsureValidToken_Success() {
        // GIVEN
        let expectation = self.expectation(description: "Token refreshed successfully")

        // WHEN
        mockExpiredTokenInKeychain()

        let mockAuthResponseDTO = AuthResponseDTO(
            data: TokenDataDTO(
                id: "1",
                type: "auth",
                attributes: TokenAttributesDTO(
                    accessToken: "newAccessToken",
                    tokenType: "bearer",
                    expiresIn: 3600,
                    refreshToken: "newRefreshToken",
                    createdAt: Int(Date().timeIntervalSince1970)
                )
            )
        )
        mockAuthRepo.result = .success(mockAuthResponseDTO)

        // THEN
        userSession.ensureValidToken()
            .sink(receiveValue: { result in
                switch result {
                case .success(let accessToken):
                    XCTAssertEqual(accessToken, "newAccessToken")
                    expectation.fulfill()
                case .failure:
                    XCTFail("Expected success but got failure")
                }
            })
            .store(in: &cancelBag)

        wait(for: [expectation], timeout: 2.0)
    }

    func testEnsureValidToken_Failure() {
        let expectation = self.expectation(description: "Token refresh failed")

        mockExpiredTokenInKeychain()

        mockAuthRepo.result = .failure(.customError("Refresh token failed"))

        userSession.ensureValidToken()
            .sink(receiveValue: { result in
                switch result {
                case .success:
                    XCTFail("Expected failure but got success")
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, "Refresh token failed")
                    expectation.fulfill()
                }
            })
            .store(in: &cancelBag)

        wait(for: [expectation], timeout: 2.0)
    }

    private func mockExpiredTokenInKeychain() {
        userSession.keychain.storeData(keyValue: (.accessToken, "expiredAccessToken"))
        userSession.keychain.storeData(keyValue: (.refreshToken, "validRefreshToken"))
        userSession.keychain.storeData(keyValue: (.createdAt, Int(Date().timeIntervalSince1970 - 4000))) // Expired token
        userSession.keychain.storeData(keyValue: (.expiresIn, 3600))
    }
}
