//
//  NetworkManagerTest.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/6/24.
//

import Foundation
import XCTest
import Alamofire

@testable import NimbleCodeChallenge

class NetworkManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRequestSuccess() {
        let expectedData = DummyResponse(name: "Test")
        let jsonData = try! JSONEncoder().encode(expectedData)

        let networkManager: NetworkManager = NetworkManager.shared()
        networkManager.configUserSession(userSession: nil)
        networkManager.configSession(session: Session.createMockSession(mockData: jsonData))

        let expectation = self.expectation(description: "Request should succeed")

        networkManager.request("https://example.com", method: .get, parameters: nil) { (result: Result<DummyResponse, NetworkError>) in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.name, "Test")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
    func testRequestFailure() {
        let networkManager: NetworkManager = NetworkManager.shared()
        networkManager.configUserSession(userSession: nil)
        networkManager.configSession(session: Session.createMockSession(mockError: NSError(domain: "test", code: 400, userInfo: nil)))


        let expectation = self.expectation(description: "Request should fail")

        NetworkManager.shared().request("https://example.com", method: .get, parameters: nil) { (result: Result<AuthResponseDTO, NetworkError>) in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (test error 400.)")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testRefreshSuccess() {
        let expectedData = MockManager.loadJSON(from: .authResponse, as: AuthResponseDTO.self)
        let jsonData = try! JSONEncoder().encode(expectedData)

        let networkManager: NetworkManager = NetworkManager.shared()
        networkManager.configUserSession(userSession: nil)
        networkManager.configSession(session: Session.createMockSession(mockData: jsonData))

        let expectation = self.expectation(description: "Request should succeed")

        networkManager.refreshToken(url:"https://example.com", method: .get, parameters: nil) { (result: Result<AuthResponseDTO, NetworkError>) in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response, "The mock file was not loaded successfully.")

                XCTAssertEqual(response.data.id, "123", "The 'id' field does not match.")
                XCTAssertEqual(response.data.type, "token", "The 'type' field does not match.")
                XCTAssertEqual(response.data.attributes.accessToken, "123-f2i0CG6MDsf-wJE9FyYrhSGAOtxBkhYWDI", "The 'access_token' does not match.")
                XCTAssertEqual(response.data.attributes.tokenType, "Bearer", "The 'token_type' field does not match.")
                XCTAssertEqual(response.data.attributes.expiresIn, 7200, "The 'expires_in' field does not match.")
                XCTAssertEqual(response.data.attributes.refreshToken, "l27GNT0kmkPbnEaUxniXyu4cHfPyWFr00kZTX5oWKA6c", "The 'refresh_token' does not match.")
                XCTAssertEqual(response.data.attributes.createdAt, 1681974651, "The 'created_at' field does not match.")

                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testRefreshFailure() {
        let networkManager: NetworkManager = NetworkManager.shared()
        networkManager.configUserSession(userSession: nil)
        networkManager.configSession(session: Session.createMockSession(mockError: NSError(domain: "test", code: 400, userInfo: nil)))

        let expectation = self.expectation(description: "Request should fail")

        networkManager.refreshToken(url:"https://example.com", method: .get, parameters: nil) { (result: Result<AuthResponseDTO, NetworkError>) in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (test error 400.)")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testEnsureValidTokenSuccess() {
        // GIVEN
        let expectedData = DummyResponse(name: "Test")
        let jsonData = try! JSONEncoder().encode(expectedData)
        let mockUserSession = MockUserSession()
        mockUserSession.ensureValidTokenResult = .success("123456")

        let networkManager: NetworkManager = NetworkManager.shared()
        networkManager.configUserSession(userSession: mockUserSession)
        networkManager.configSession(session: Session.createMockSession(mockData: jsonData))

        let expectation = self.expectation(description: "Request should succeed")
        // WHEN
        networkManager.request("https://example.com", method: .get, parameters: nil) { (result: Result<DummyResponse, NetworkError>) in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.name, "Test")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testEnsureValidTokenFailed() {
        // GIVEN
        let expectedData = DummyResponse(name: "Test")
        let jsonData = try! JSONEncoder().encode(expectedData)
        let mockUserSession = MockUserSession()
        mockUserSession.ensureValidTokenResult = .failure(.unknownError)

        let networkManager: NetworkManager = NetworkManager.shared()
        networkManager.configUserSession(userSession: mockUserSession)
        networkManager.configSession(session: Session.createMockSession(mockData: jsonData))

        let neededAPI = "https://example.com"

        // WHEN
        networkManager.request(neededAPI, method: .get, parameters: nil) { (result: Result<DummyResponse, NetworkError>) in

        }

        let callNeededAPIProgress = networkManager.trackProgress(for: neededAPI)
        XCTAssertNil(callNeededAPIProgress, "Progress will nil when the refresh token progress is failed")

    }

}

struct DummyResponse: Codable {
    let name: String
}
