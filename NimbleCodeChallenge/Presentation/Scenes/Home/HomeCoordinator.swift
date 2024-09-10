//
//  HomeCoordinator.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/3/24.
//

import Foundation
import Stinsen
import SwiftUI

final class HomeCoordinator: NavigationCoordinatable {
    var stack = NavigationStack(initial: \HomeCoordinator.start)
    
    @Root var start = makeHome
    
    @ViewBuilder
    func makeHome() -> some View {
        let coordinator = HomeCoordinator()
        let surveyRepo = SurveyRepository()
        let homeUsecase = HomeUseCase(surveyRepo: surveyRepo)
        let viewModel = HomeViewModel(homeUseCase: homeUsecase)
        
        HomeScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
     func makeSurveySucess() -> some View {
         SucessSurvey()
     }
}

