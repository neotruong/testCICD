//
//  AuthResponseDTOTest.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/5/24.
//

import XCTest
@testable import NimbleCodeChallenge

final class AuthResponseDTOTests: XCTestCase {

    func testAuthResponseDTOFromMock() {
        let authResponse: AuthResponseDTO? = MockManager.loadJSON(from: .authResponse, as: AuthResponseDTO.self)

        XCTAssertNotNil(authResponse, "The mock file was not loaded successfully.")

        XCTAssertEqual(authResponse?.data.id, "123", "The 'id' field does not match.")
        XCTAssertEqual(authResponse?.data.type, "token", "The 'type' field does not match.")
        XCTAssertEqual(authResponse?.data.attributes.accessToken, "123-f2i0CG6MDsf-wJE9FyYrhSGAOtxBkhYWDI", "The 'access_token' does not match.")
        XCTAssertEqual(authResponse?.data.attributes.tokenType, "Bearer", "The 'token_type' does not match.")
        XCTAssertEqual(authResponse?.data.attributes.expiresIn, 7200, "The 'expires_in' field does not match.")
        XCTAssertEqual(authResponse?.data.attributes.refreshToken, "l27GNT0kmkPbnEaUxniXyu4cHfPyWFr00kZTX5oWKA6c", "The 'refresh_token' does not match.")
        XCTAssertEqual(authResponse?.data.attributes.createdAt, 1681974651, "The 'created_at' field does not match.")
    }
}

