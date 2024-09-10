//
//  AuthResponseDTOTest.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/5/24.
//

import Foundation
import XCTest
@testable import NimbleCodeChallenge

final class SurveyResponseDTOTests: XCTestCase {

    func testSurveyResponseDTO_Decoding() {
        // Load the mock JSON from file
        guard let surveyResponse: SurveyResponseDTO = MockManager.loadJSON(from: .surveyResponse, as: SurveyResponseDTO.self) else {
            XCTFail("Failed to load survey response from mock file")
            return
        }

        // Perform assertions on the decoded data
        XCTAssertEqual(surveyResponse.data.count, 1, "The data array should contain one survey item.")

        let firstSurvey = surveyResponse.data.first
        XCTAssertEqual(firstSurvey?.id, "d5de6a8f8f5f1cfe51bc", "The survey ID should match the mock data.")
        XCTAssertEqual(firstSurvey?.type, "survey_simple", "The survey type should match the mock data.")
        XCTAssertEqual(firstSurvey?.attributes.title, "Scarlett Bangkok", "The survey title should match the mock data.")
        XCTAssertEqual(firstSurvey?.attributes.description, "We'd love ot hear from you!", "The survey description should match the mock data.")
        XCTAssertTrue(firstSurvey?.attributes.isActive ?? false, "The survey should be active.")
        XCTAssertEqual(firstSurvey?.attributes.coverImageURL, "https://dhdbhh0jsld0o.cloudfront.net/m/1ea51560991bcb7d00d0_", "The cover image URL should match the mock data.")

        // Verify meta data
        XCTAssertEqual(surveyResponse.meta.page, 1, "The page number should match the mock data.")
        XCTAssertEqual(surveyResponse.meta.pages, 20, "The total number of pages should match the mock data.")
        XCTAssertEqual(surveyResponse.meta.pageSize, 1, "The page size should match the mock data.")
        XCTAssertEqual(surveyResponse.meta.records, 20, "The total number of records should match the mock data.")
    }
}
