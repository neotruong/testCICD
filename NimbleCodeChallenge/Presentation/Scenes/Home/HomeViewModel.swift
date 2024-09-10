//
//  AuthViewModel.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/2/24.
//

import Foundation
import Combine

extension HomeViewModel {
    class Input: ObservableObject {
        let onAppear: PassthroughSubject<Void, Never>
        let onRefresh: PassthroughSubject<Void, Never>
        init() {
            self.onAppear = .init()
            self.onRefresh = .init()
        }
    }

    class Output: ObservableObject {
        let onError: PassthroughSubject<String, Never> = .init()
        @Published var isLoading = false
        @Published var currentPage = 0
        @Published var cacheImageURL: [String] = []
        @Published var didFirstLoad: Bool = true
        @Published var surveyData: SurveyData = .init(listSurvey: [], pageSize: 0, pageNumber: 0, maxPage: 0)
    }
}

final class HomeViewModel: BaseViewModel {

    let homeUseCase: HomeUseCaseProtocol
    let userSession: UserSessionProtocol
    private let cancelBag = CancelBag()

    init(homeUseCase: HomeUseCaseProtocol, userSession: UserSessionProtocol) {
        self.homeUseCase = homeUseCase
        self.userSession = userSession
    }

    func transform(_ input: Input) -> Output {
        let output = Output()

        input.onRefresh
            .handleEvents(receiveOutput: { _ in
                output.surveyData = .init(listSurvey: [], pageSize: 0, pageNumber: 0, maxPage: 0)
                output.currentPage = 0
            })
            .delay(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .map { _ in
                self.homeUseCase.fetchListSurveyItems(token: self.userSession.getAccessToken() ?? "")
                    .asDriver()
            }
            .switchToLatest()
            .sink(receiveValue: { response in
                switch response {
                case .success(let surveyData):
                    output.cacheImageURL = surveyData.listSurvey.map { $0.coverImage }
                    output.surveyData = surveyData
                case .failure(let error):
                    output.onError.send(error.localizedDescription)
                }
            })
            .store(in: cancelBag)

        input.onAppear
            .map { _ in
                self.homeUseCase.fetchListSurveyItems(token: self.userSession.getAccessToken() ?? "")
                    .asDriver()
            }
            .switchToLatest()
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .sink(receiveValue: { response in
                switch response {
                case .success(let surveyData):
                    output.cacheImageURL = surveyData.listSurvey.map { $0.coverImage }
                    output.didFirstLoad = false
                    output.surveyData = surveyData
                case .failure(let error):
                    output.onError.send(error.localizedDescription)
                }
            })
            .store(in: cancelBag)

        return output
    }

}
