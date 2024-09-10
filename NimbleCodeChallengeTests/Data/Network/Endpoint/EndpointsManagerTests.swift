//
//  EndPointTest.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/6/24.
//

import Foundation
import XCTest
@testable import NimbleCodeChallenge

enum MockEndPoint: String {
    case user = "/user"
    case product = "/product"
}

class MockService: EndPointProtocol {
    typealias EndPointType = MockEndPoint

    func getEndPoint(type: MockEndPoint) -> String {
        return type.rawValue
    }
}

class EndpointsManagerTests: XCTestCase {

    var endpointsManager: EndpointsManager!
    var mockService: MockService!

    override func setUp() {
        super.setUp()
        endpointsManager = EndpointsManager.shared
        mockService = MockService()
    }

    override func tearDown() {
        endpointsManager = nil
        mockService = nil
        super.tearDown()
    }

    func testGetEndPoints_UserEndPoint() {
        // Given
        let expectedURL = ConfigHelper.baseURL + ConfigHelper.apiVersion + MockEndPoint.user.rawValue

        // When
        let actualURL = endpointsManager.getEndPoints(for: mockService, type: .user)

        // Then
        XCTAssertEqual(actualURL, expectedURL, "The returned endpoint URL should be correct")
    }

    func testGetEndPoints_ProductEndPoint() {
        // Given
        let expectedURL = ConfigHelper.baseURL + ConfigHelper.apiVersion + MockEndPoint.product.rawValue

        // When
        let actualURL = endpointsManager.getEndPoints(for: mockService, type: .product)

        // Then
        XCTAssertEqual(actualURL, expectedURL, "The returned endpoint URL should be correct")
    }
}
