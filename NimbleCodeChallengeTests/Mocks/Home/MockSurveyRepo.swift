//
//  MockSurveyRepo.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/4/24.
//

import Foundation
import Combine
@testable import NimbleCodeChallenge

final class MockSurveyRepo: SurveyRepoInterface {
    var result: Result<SurveyResponseDTO, NetworkError>?

    func getListSurvey(request: SurveyRequestDTO) -> AnyPublisher<Result<SurveyResponseDTO, NetworkError>, Never> {
        return Just(result!)
            .eraseToAnyPublisher()
    }
}
