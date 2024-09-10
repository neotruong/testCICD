//
//  AuthRepositoryTest.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/7/24.
//


import Foundation
import XCTest
import Alamofire
import Combine

@testable import NimbleCodeChallenge

class AuthRepositoryTests: XCTestCase {

    var authRepository: AuthRepository!
    var mockNetworkRepository: MockNetworkRepository!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockNetworkRepository = MockNetworkRepository()
        authRepository = AuthRepository(network: mockNetworkRepository)
    }

    override func tearDown() {
        super.tearDown()
        authRepository = nil
        mockNetworkRepository = nil
        cancellables.removeAll()
    }

    func testLoginWithEmailOrTokenSuccess() {
        let expectedResponse = MockManager.loadJSON(from: .authResponse, as: AuthResponseDTO.self)
        mockNetworkRepository.mockRequestResult = Result<AuthResponseDTO, NetworkError>.success(expectedResponse!)

        let requestDTO = AuthRequestDTO(grantType: .password, email: "", password: "", clientId: "", clientSecret: "")

        let expectation = self.expectation(description: "Login should succeed")

        authRepository.loginWithEmailOrToken(request: requestDTO)
            .sink(receiveValue: { result in
                switch result {
                case .success(let response):
                    XCTAssertEqual(response.data.attributes.accessToken, "123-f2i0CG6MDsf-wJE9FyYrhSGAOtxBkhYWDI")
                    expectation.fulfill()
                case .failure:
                    XCTFail("Expected success but got failure")
                }
            })
            .store(in: &self.cancellables)

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testLoginWithEmailOrTokenFailure() {
        mockNetworkRepository.mockRequestResult =  Result<AuthResponseDTO, NetworkError>.failure(.unknownError)

        let requestDTO = AuthRequestDTO(grantType: .password, email: "", password: "", clientId: "", clientSecret: "")

        let expectation = self.expectation(description: "Login should fail")

        authRepository.loginWithEmailOrToken(request: requestDTO)
            .sink(receiveValue: { result in
                switch result {
                case .success:
                    XCTFail("Expected failure but got success")
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, "An unknown error occurred.")
                    expectation.fulfill()
                }
            })
            .store(in: &self.cancellables)

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testRefreshTokenSuccess() {
        let expectedResponse = MockManager.loadJSON(from: .authResponse, as: AuthResponseDTO.self)
        mockNetworkRepository.mockRefreshTokenResult = .success(expectedResponse!)

        let requestDTO = AuthRefreshTokenDTO(grantType: .refreshToken, clientId: "", clientSecret: "")
        let expectation = self.expectation(description: "Token refresh should succeed")

        authRepository.refreshToken(request: requestDTO)
            .sink(receiveValue: { result in
                switch result {
                case .success(let response):
                    XCTAssertEqual(response.data.attributes.accessToken, "123-f2i0CG6MDsf-wJE9FyYrhSGAOtxBkhYWDI")
                    expectation.fulfill()
                case .failure:
                    XCTFail("Expected success but got failure")
                }
            })
            .store(in: &self.cancellables)

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testRefreshTokenFailure() {
        mockNetworkRepository.mockRefreshTokenResult = .failure(.customError("Token refresh failed"))

        let requestDTO = AuthRefreshTokenDTO(grantType: .refreshToken, clientId: "", clientSecret: "")

        let expectation = self.expectation(description: "Token refresh should fail")

        authRepository.refreshToken(request: requestDTO)
            .sink(receiveValue: { result in
                switch result {
                case .success:
                    XCTFail("Expected failure but got success")
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, "Token refresh failed")
                    expectation.fulfill()
                }
            })
            .store(in: &self.cancellables)

        waitForExpectations(timeout: 1, handler: nil)
    }
}
