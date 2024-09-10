//
//  AuthRepository.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/1/24.
//

import Foundation
import Combine
import Alamofire

final class SurveyRepository: SurveyRepoInterface {

    let network: NetworkRepositoryProtocol

    init(network: NetworkRepositoryProtocol = NetworkManager.shared()) {
        self.network = network
    }

    func getListSurvey(request: SurveyRequestDTO) -> AnyPublisher<Result<SurveyResponseDTO, NetworkError>, Never> {
        let network = network
        let endpoint = EndpointsManager.shared.getEndPoints(for: SurveyEndPoint(), type: .getList)

        let parameters: Parameters = [
            "page[number]": request.pageNumber as Any,
            "page[size]": request.pageSize as Any
        ]

        return Future { promise in
            network.request(endpoint, method: .get,
                            parameters: parameters) { (result: Result<SurveyResponseDTO, NetworkError>) in
                promise(.success(result))
            }
        }
        .eraseToAnyPublisher()
    }
}
