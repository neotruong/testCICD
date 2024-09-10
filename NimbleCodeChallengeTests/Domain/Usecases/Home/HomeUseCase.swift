//
//  SurveyUsecase.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/4/24.
//

import Foundation
import XCTest
import Combine
@testable import NimbleCodeChallenge

final class HomeUseCaseTests: XCTestCase {

    private var homeUseCase: HomeUseCase!
    private var mockSurveyRepo: MockSurveyRepo!
    private var cancelBag = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        mockSurveyRepo = MockSurveyRepo()
        homeUseCase = HomeUseCase(surveyRepo: mockSurveyRepo)
    }

    func testFetchListSurveyItemsSuccess() {
        let expectation = self.expectation(description: "Successfully fetched survey list")

        let mockSurveyResponseDTO = SurveyResponseDTO(
            data: [
                SurveyDTO(
                    id: "1",
                    type: "survey",
                    attributes: SurveyAttributesDTO(
                        title: "Survey 1",
                        description: "We'd love ot hear from you",
                        thankEmailAboveThreshold: "",
                        thankEmailBelowThreshold: "",
                        isActive: false,
                        coverImageURL: "https://example.com/survey2_cover.jpg",
                        createdAt: "",
                        activeAt: "",
                        inactiveAt: "",
                        surveyType: ""
                    )
                ),
                SurveyDTO(
                    id: "2",
                    type: "survey",
                    attributes: SurveyAttributesDTO(
                        title: "Survey 2",
                        description: "We'd love ot hear from you",
                        thankEmailAboveThreshold: "",
                        thankEmailBelowThreshold: "",
                        isActive: false,
                        coverImageURL: "https://example.com/survey2_cover.jpg",
                        createdAt: "",
                        activeAt: "",
                        inactiveAt: "",
                        surveyType: ""
                    )
                )
            ],
            meta: MetaDTO(
                page: 1,
                pages: 5,
                pageSize: 10,
                records: 50
            )
        )
        mockSurveyRepo.result = .success(mockSurveyResponseDTO)

        homeUseCase.fetchListSurveyItems(token: "mockToken")
            .sink(receiveValue: { result in
                switch result {
                case .success(let surveyData):
                    XCTAssertEqual(surveyData.listSurvey.count, 2)
                    XCTAssertEqual(surveyData.listSurvey[0].name, "Survey 1")
                    XCTAssertEqual(surveyData.pageSize, 10)
                    XCTAssertEqual(surveyData.pageNumber, 1)
                    expectation.fulfill()
                case .failure:
                    XCTFail("Expected success but got failure")
                }
            })
            .store(in: &cancelBag)

        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchListSurveyItemsFailure() {
          let expectation = self.expectation(description: "Failed to fetch survey list")

          mockSurveyRepo.result = .failure(.customError("Network error"))

          homeUseCase.fetchListSurveyItems(token: "mockToken")
              .sink(receiveValue: { result in
                  switch result {
                  case .success:
                      XCTFail("Expected failure but got success")
                  case .failure(let error):
                      XCTAssertEqual(error.localizedDescription, "Network error")
                      expectation.fulfill()
                  }
              })
              .store(in: &cancelBag)

          wait(for: [expectation], timeout: 2.0)
      }
}
