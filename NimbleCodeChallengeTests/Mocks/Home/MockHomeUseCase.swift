//
//  MockHomeUseCase.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/5/24.
//

import Foundation
import Combine
@testable import NimbleCodeChallenge

final class MockHomeUseCase: HomeUseCaseProtocol {
    var result: Result<SurveyData, NetworkError>?

    func fetchListSurveyItems(token: String) -> AnyPublisher<Result<SurveyData, NetworkError>, Never> {
        return Just(result!)
            .eraseToAnyPublisher()
    }

    func mappingDTO(_ dtoData: SurveyResponseDTO) -> SurveyData {
        return SurveyData(listSurvey: [], pageSize: 0, pageNumber: 0, maxPage: 0)
    }
}
