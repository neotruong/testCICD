//
//  HomeViewModelTest.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/5/24.
//

import Foundation
import XCTest
import Combine
@testable import NimbleCodeChallenge

final class HomeViewModelTests: XCTestCase {

    private var viewModel: HomeViewModel!
    private var mockHomeUseCase: MockHomeUseCase!
    private var mockUserSession: MockUserSession!
    private var cancelBag: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockHomeUseCase = MockHomeUseCase()
        mockUserSession = MockUserSession()
        viewModel = HomeViewModel(homeUseCase: mockHomeUseCase, userSession: mockUserSession)
    }

    override func tearDown() {
        cancelBag = []
        super.tearDown()
    }

    func testOnAppearLoadsDataSuccessfully() {
        // Given
        let input = HomeViewModel.Input()
        let output = viewModel.transform(input)

        let expectation = XCTestExpectation(description: "Data is loaded successfully onAppear")

        let mockSurveyData = SurveyData(
            listSurvey: [SurveyItem(coverImage: "image1", name: "Survey 1", description: "Description 1")],
            pageSize: 10,
            pageNumber: 1,
            maxPage: 5
        )
        mockHomeUseCase.result = .success(mockSurveyData)

        // When
        input.onAppear.send(())

        output.$surveyData
            .dropFirst()
            .sink { surveyData in
                XCTAssertEqual(surveyData.listSurvey.count, 1)
                XCTAssertEqual(surveyData.listSurvey.first?.name, "Survey 1")
                expectation.fulfill()
            }
            .store(in: &cancelBag)

        // Then
        wait(for: [expectation], timeout: 2.0)
    }

    func testOnRefreshClearsAndReloadsData() {
        // Given
        let input = HomeViewModel.Input()
        let output = viewModel.transform(input)

        let expectation = XCTestExpectation(description: "Data is cleared and reloaded successfully onRefresh")

        let mockSurveyData = SurveyData(
            listSurvey: [SurveyItem(coverImage: "image2", name: "Survey 2", description: "Description 2")],
            pageSize: 10,
            pageNumber: 1,
            maxPage: 5
        )
        mockHomeUseCase.result = .success(mockSurveyData)

        // When
        input.onRefresh.send(())

        output.$surveyData
            .dropFirst() // To ignore the initial value
            .sink { surveyData in
                XCTAssertEqual(surveyData.listSurvey.count, 1)
                XCTAssertEqual(surveyData.listSurvey.first?.name, "Survey 2")
                expectation.fulfill()
            }
            .store(in: &cancelBag)

        // Then
        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchFailsOnError() {
        // Given
        let input = HomeViewModel.Input()
        let output = viewModel.transform(input)

        let expectation = XCTestExpectation(description: "Error is triggered when fetch fails")

        mockHomeUseCase.result = .failure(.customError("Failed to load data"))

        // When
        input.onAppear.send(())

        output.onError
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "Failed to load data")
                expectation.fulfill()
            }
            .store(in: &cancelBag)

        // Then
        wait(for: [expectation], timeout: 2.0)
    }
}
