//
//  HomeUseCaseProtocol.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/3/24.
//

import Foundation
import Combine

protocol HomeUseCaseProtocol {
    func fetchListSurveyItems(token: String) -> AnyPublisher<Result<SurveyData, NetworkError>, Never>
    func mappingDTO(_ dtoData: SurveyResponseDTO) -> SurveyData 
}

final class HomeUseCase: HomeUseCaseProtocol {
    
    private let surveyRepo: SurveyRepoInterface
    
    init(surveyRepo: SurveyRepoInterface) {
        self.surveyRepo = surveyRepo
    }
    
    func fetchListSurveyItems(token: String) -> AnyPublisher<Result<SurveyData, NetworkError>, Never> {
        let surveyRequest: SurveyRequestDTO = SurveyRequestDTO(token: token)
        
        return surveyRepo.getListSurvey(request: surveyRequest)
            .map { result in
                result.map { self.mappingDTO($0) }
            }
            .eraseToAnyPublisher()
    }
    
    func mappingDTO(_ dtoData: SurveyResponseDTO) -> SurveyData {
        let surveyItems = dtoData.data.map {
            SurveyItem(coverImage: $0.attributes.coverImageURL,
                       name: $0.attributes.title,
                       description: $0.attributes.description)
        }
        let surveyData = SurveyData(listSurvey: surveyItems, 
                                    pageSize: dtoData.meta.pageSize,
                                    pageNumber: dtoData.meta.page,
                                    maxPage: dtoData.meta.pages)

        return surveyData
    }
}
