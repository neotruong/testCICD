//
//  LoginViewModelTest.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/4/24.
//
import XCTest
import Combine
@testable import NimbleCodeChallenge

final class AuthViewModelTests: XCTestCase {

    private var viewModel: AuthViewModel!
    private var mockLoginUseCase: MockLoginUseCase!
    private var mockUserSession: MockUserSession!
    private var cancelBag: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockLoginUseCase = MockLoginUseCase()
        mockUserSession = MockUserSession()
        viewModel = AuthViewModel(loginUseCase: mockLoginUseCase, userSession: mockUserSession)
    }

    override func tearDown() {
        cancelBag = []
        super.tearDown()
    }


    func testLoginButtonEnabled() {
        // Given
        let input = AuthViewModel.Input()
        let output = viewModel.transform(input)

        let expectation = XCTestExpectation(description: "Login button is enabled")

        // When
        input.emailTextField = "test@example.com"
        input.passwordTextField = "validPassword"

        output.$isLoginEnabled
            .sink { isEnabled in
                if isEnabled {
                    expectation.fulfill()
                }
            }
            .store(in: &cancelBag)

        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(output.isLoginEnabled)
    }

    func testLoginSuccess() {
        // Given
        let input = AuthViewModel.Input()
        let output = viewModel.transform(input)

        let expectation = XCTestExpectation(description: "Login success")

        // Simulate valid login response
        mockLoginUseCase.result = .success(AuthData(accessToken: "accessToken", refreshToken: "refreshToken", expiresIn: 3600, createdAt: Int(Date().timeIntervalSince1970)))

        // When
        input.emailTextField = "test@example.com"
        input.passwordTextField = "validPassword"
        input.loginButtonTrigger.send(())

        output.onLoginSuccess
            .sink {
                expectation.fulfill()
            }
            .store(in: &cancelBag)

        // Then
        wait(for: [expectation], timeout: 2.0)
    }

    func testLoginFailure() {
        // Given
        let input = AuthViewModel.Input()
        let output = viewModel.transform(input)

        let expectation = XCTestExpectation(description: "Login failure")

        mockLoginUseCase.result = .failure(.customError("Invalid credentials"))

        // When
        input.emailTextField = "test@example.com"
        input.passwordTextField = "invalidPassword"
        input.loginButtonTrigger.send(())

        output.onError
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "Invalid credentials")
                expectation.fulfill()
            }
            .store(in: &cancelBag)

        // Then
        wait(for: [expectation], timeout: 2.0)
    }

    func testLoadingState() {
        // Given
        let input = AuthViewModel.Input()
        let output = viewModel.transform(input)

        let expectation = XCTestExpectation(description: "Loading state changes correctly")

        var loadingStates: [Bool] = []

        // Simulate valid login response
        mockLoginUseCase.result = .success(AuthData(accessToken: "accessToken", refreshToken: "refreshToken", expiresIn: 3600, createdAt: Int(Date().timeIntervalSince1970)))

        // When
        output.$isLoading
            .sink { isLoading in
                loadingStates.append(isLoading)
                if loadingStates.count == 3 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancelBag)

        input.emailTextField = "test@example.com"
        input.passwordTextField = "validPassword"
        input.loginButtonTrigger.send(())

        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(loadingStates, [false, true, false])
    }
}
