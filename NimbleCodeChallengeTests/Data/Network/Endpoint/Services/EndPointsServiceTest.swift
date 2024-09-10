//
//  EndPointsServiceTest.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/6/24.
//

import Foundation
import XCTest
@testable import NimbleCodeChallenge

class EndPointsServiceTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAllAuthEndpoints() {
        var authEndpoint: AuthEndpoint = AuthEndpoint()

        // Given
        let expectedEndpoints: [AuthEndpoint.EndpointType: String] = [
            .login: "oauth/token",
            .forgotPassword: "password"
        ]

        // When & Then
        for (type, expectedValue) in expectedEndpoints {
            let actualValue = authEndpoint.getEndPoint(type: type)
            XCTAssertEqual(actualValue, expectedValue, "The endpoint for \(type) should be \(expectedValue).")
        }
    }

    func testAllSurveyEndpoints() {
        var authEndpoint: SurveyEndPoint = SurveyEndPoint()

        // Given
        let expectedEndpoints: [SurveyEndPoint.EndpointType: String] = [
            .getList: "surveys",
        ]

        // When & Then
        for (type, expectedValue) in expectedEndpoints {
            let actualValue = authEndpoint.getEndPoint(type: type)
            XCTAssertEqual(actualValue, expectedValue, "The endpoint for \(type) should be \(expectedValue).")
        }
    }
}
