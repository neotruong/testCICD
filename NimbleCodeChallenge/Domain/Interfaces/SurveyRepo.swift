//
//  SurveyRepo.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/3/24.
//

import Foundation
import Combine

protocol SurveyRepoInterface {
    func getListSurvey(request: SurveyRequestDTO) -> AnyPublisher<Result<SurveyResponseDTO, NetworkError>, Never>
}
