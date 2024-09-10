//
//  NimbleCodeChallengeApp.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 8/28/24.
//

import SwiftUI
import IQKeyboardManagerSwift
import Alamofire

@main
struct NimbleCodeChallengeApp: App {

  init() {
    IQKeyboardManager.shared.enable = true
  }

  var body: some Scene {
    WindowGroup {
      let authRepository = AuthRepository()
      let loginUseCase = LoginUseCase(authRepo: authRepository)
      let homeUseCase = HomeUseCase(surveyRepo: SurveyRepository())
      let keychain = KeychainHelper()
      let userSessionRepo = UserSessionRepo(keychain: keychain, authRepo: authRepository)
      let router = MainRouterViewModel(userSession: UserSession(userSessionRepo: userSessionRepo))
      let networkSession = Session(interceptor: AuthInterceptor(userSession: userSessionRepo))

      MainRouter(router: router,
                   authRepository: authRepository,
                   loginUseCase: loginUseCase,
                   homeUseCase: homeUseCase)
            .onAppear {

                NetworkManager.shared().configUserSession(userSession: userSessionRepo)
                NetworkManager.shared().configSession(session: networkSession)
                authRepository.userSession = userSessionRepo
            }
        }
  }
}
