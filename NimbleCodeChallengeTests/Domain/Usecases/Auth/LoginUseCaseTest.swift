//
//  LoginUseCaseTest.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/4/24.
//

import Foundation
import XCTest
import Combine
@testable import NimbleCodeChallenge

class LoginUseCaseTests: XCTestCase {

    var loginUseCase: LoginUseCase!
    var mockAuthRepo: MockAuthRepo!
    var cancelBag = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        mockAuthRepo = MockAuthRepo()
        loginUseCase = LoginUseCase(authRepo: mockAuthRepo)
    }

    override func tearDown() {
        mockAuthRepo = nil
        loginUseCase = nil
        super.tearDown()
    }

    func testValidateEmail_WhenEmailIsNotEmpty_ShouldReturnTrue() {
        // Given: Valid email data
        let email = "test@example.com"

        // When: Checking email
        let isValid = loginUseCase.validateEmail(email: email)

        // Then: The email should be valid
        XCTAssertTrue(isValid, "The email should be valid when it's not empty")
    }

    func testValidateEmail_WhenEmailIsEmpty_ShouldReturnFalse() {
        // Given: Empty email string
        let email = ""

        // When: Checking email
        let isValid = loginUseCase.validateEmail(email: email)

        // Then: The email should be invalid
        XCTAssertFalse(isValid, "The email should be invalid when it's empty")
    }

    func testValidatePassword_WhenPasswordIsNotEmpty_ShouldReturnTrue() {
        // Given: A non-empty password
        let password = "password123"

        // When: Checking the password
        let isValid = loginUseCase.validatePassword(password: password)

        // Then: The password should be valid
        XCTAssertTrue(isValid, "The password should be valid when it's not empty")
    }

    func testValidatePassword_WhenPasswordIsEmpty_ShouldReturnFalse() {
        // Given: An empty password
        let password = ""

        // When: Checking the password
        let isValid = loginUseCase.validatePassword(password: password)

        // Then: The password should be invalid
        XCTAssertFalse(isValid, "The password should be invalid when it's empty")
    }

    func testLoginWithPassword_WhenCredentialsAreValid_ShouldReturnSuccess() {
        // Given: Valid login information
        let email = "test@example.com"
        let password = "password123"

        let expectedAuthData = AuthResponseDTO(
            data: TokenDataDTO(
                id: "123456",
                type: "token",
                attributes: TokenAttributesDTO(
                    accessToken: "mockAccessToken123",
                    tokenType: "bearer",
                    expiresIn: 3600,
                    refreshToken: "mockRefreshToken123",
                    createdAt: 1234567890
                )
            )
        )

        mockAuthRepo.result = .success(expectedAuthData)

        // When: Logging in with email and password
        let expectation = self.expectation(description: "Login should return success")
        loginUseCase.loginWithPassword(email: email, password: password)
            .sink(receiveValue: { result in
                // Then: The login should be successful and return AuthData
                switch result {
                case .success(let authData):
                    XCTAssertEqual(authData.accessToken, expectedAuthData.data.attributes.accessToken)
                    XCTAssertEqual(authData.refreshToken, expectedAuthData.data.attributes.refreshToken)
                    XCTAssertEqual(authData.expiresIn, expectedAuthData.data.attributes.expiresIn)
                    XCTAssertEqual(authData.createdAt, expectedAuthData.data.attributes.createdAt)
                    expectation.fulfill()
                case .failure:
                    XCTFail("Login should not fail with valid credentials")
                }
            })
            .store(in: &cancelBag)

        wait(for: [expectation], timeout: 2.0)
    }

    func testLoginWithPassword_WhenCredentialsAreInvalid_ShouldReturnFailure() {
        // Given: Invalid email and password
        let email = "invalid@example.com"
        let password = "wrongpassword"

        mockAuthRepo.result = .failure(NetworkError.customError("Invalid credentials"))

        // When: Attempting to log in with invalid credentials
        let expectation = self.expectation(description: "Login should return failure")
        loginUseCase.loginWithPassword(email: email, password: password)
            .sink(receiveValue: { result in
                switch result {
                case .success:
                    XCTFail("Login should fail with invalid credentials")
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, "Invalid credentials")
                    expectation.fulfill()
                }
            })
            .store(in: &cancelBag)

        wait(for: [expectation], timeout: 2.0)
    }

    func testMappingDTO_ShouldMapDTOToAuthDataCorrectly() {
        let dtoData = AuthResponseDTO(data: TokenDataDTO(id: "", type: "", attributes: .init(accessToken: "accessToken123", tokenType: "", expiresIn: 3600, refreshToken: "refreshToken123", createdAt: 1234567890)))

           let authData = loginUseCase.mappingDTO(dtoData)

           XCTAssertEqual(authData.accessToken, "accessToken123")
           XCTAssertEqual(authData.refreshToken, "refreshToken123")
           XCTAssertEqual(authData.expiresIn, 3600)
           XCTAssertEqual(authData.createdAt, 1234567890)
       }
}

