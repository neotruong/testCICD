//
//  SurveyDataTest.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/4/24.
//

import XCTest
@testable import NimbleCodeChallenge

class SurveyDataTests: XCTestCase {

    func testSurveyDataInitialization() {

        // Given: a list of SurveyItems and pagination values
        let surveyItems = [
            SurveyItem(coverImage: "https://example.com/image1.jpg", name: "Survey 1", description: "Description 1"),
            SurveyItem(coverImage: "https://example.com/image2.jpg", name: "Survey 2", description: "Description 2")
        ]
        let pageSize = 10
        let pageNumber = 1
        let maxPage = 5

        // When: initializing SurveyData
        let surveyData = SurveyData(listSurvey: surveyItems, pageSize: pageSize, pageNumber: pageNumber, maxPage: maxPage)

        // Then: the SurveyData should contain the correct values
        XCTAssertEqual(surveyData.listSurvey.count, 2, "There should be 2 survey items")
        XCTAssertEqual(surveyData.pageSize, pageSize, "Page size should match the input")
        XCTAssertEqual(surveyData.pageNumber, pageNumber, "Page number should match the input")
        XCTAssertEqual(surveyData.maxPage, maxPage, "Max page should match the input")
    }

    func testSurveyDataWithEmptyList() {
        // Given: an empty list of SurveyItems and default pagination values
        let surveyItems: [SurveyItem] = []
        let pageSize = 0
        let pageNumber = 0
        let maxPage = 1

        // When: initializing SurveyData with empty list
        let surveyData = SurveyData(listSurvey: surveyItems, pageSize: pageSize, pageNumber: pageNumber, maxPage: maxPage)

        // Then: the SurveyData should correctly represent an empty state
        XCTAssertTrue(surveyData.listSurvey.isEmpty, "Survey list should be empty")
        XCTAssertEqual(surveyData.pageSize, pageSize, "Page size should match the input")
        XCTAssertEqual(surveyData.pageNumber, pageNumber, "Page number should match the input")
        XCTAssertEqual(surveyData.maxPage, maxPage, "Max page should match the input")
    }
}
