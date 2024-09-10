//
//  SurveyRepositoryTest.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/7/24.
//

import Foundation
import XCTest
import Combine

@testable import NimbleCodeChallenge

class SurveyRepositoryTests: XCTestCase {

    var surveyRepository: SurveyRepository!
    var mockNetworkRepository: MockNetworkRepository!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockNetworkRepository = MockNetworkRepository()
        surveyRepository = SurveyRepository(network: mockNetworkRepository)
    }

    override func tearDown() {
        super.tearDown()
        surveyRepository = nil
        mockNetworkRepository = nil
        cancellables.removeAll()
    }

    func testGetListSurveySuccess() {
        let expectedResponse = MockManager.loadJSON(from: .surveyResponse, as: SurveyResponseDTO.self)
        mockNetworkRepository.mockRequestResult = Result<SurveyResponseDTO, NetworkError>.success(expectedResponse!)

        let requestDTO = SurveyRequestDTO(token: "testToken")

        let expectation = self.expectation(description: "Get list of surveys should succeed")

        surveyRepository.getListSurvey(request: requestDTO)
            .sink(receiveValue: { result in
                switch result {
                case .success(let response):
                    XCTAssertEqual(response.data.count, 1)
                    expectation.fulfill()
                case .failure:
                    XCTFail("Expected success but got failure")
                }
            })
            .store(in: &self.cancellables)

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGetListSurveyFailure() {
        mockNetworkRepository.mockRequestResult = Result<SurveyResponseDTO, NetworkError>.failure(.customError("Survey list failed"))

        let requestDTO = SurveyRequestDTO(token: "testToken")

        let expectation = self.expectation(description: "Get list of surveys should fail")

        surveyRepository.getListSurvey(request: requestDTO)
            .sink(receiveValue: { result in
                switch result {
                case .success:
                    XCTFail("Expected failure but got success")
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, "Survey list failed")
                    expectation.fulfill()
                }
            })
            .store(in: &self.cancellables)

        waitForExpectations(timeout: 1, handler: nil)
    }
}
