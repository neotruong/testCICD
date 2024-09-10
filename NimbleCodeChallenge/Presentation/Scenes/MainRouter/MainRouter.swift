//
//  MainRouter.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/4/24.
//

import Foundation
import SwiftUI
import Alamofire

struct MainRouter: View {
    @StateObject var router: MainRouterViewModel

    let authRepository: AuthRepository
    let loginUseCase: LoginUseCase
    let homeUseCase: HomeUseCase

    @State private var showSuccessSurvey = false

    init(router: MainRouterViewModel,
         authRepository: AuthRepository,
         loginUseCase: LoginUseCase,
         homeUseCase: HomeUseCase) {
        _router = StateObject(wrappedValue: router)
        self.authRepository = authRepository
        self.loginUseCase = loginUseCase
        self.homeUseCase = homeUseCase
    }

    var body: some View {
        ZStack {
            switch router.currentPage {
            case .splash:
                SplashScreen(onFinishAnimation: {
                  router.handleSplashScreenCompletion()
                })
                .environmentObject(router)
            case .login:
                AuthScreen(viewModel: AuthViewModel(loginUseCase: loginUseCase,
                                                    userSession: router.userSession), onLogin: {
                    router.navigateToHome()
                }, onForgotPassword: {
                    router.navigateToForgotPassword()
                })
                .environmentObject(router)
            case .home:
                HomeScreen(viewModel: HomeViewModel(homeUseCase: homeUseCase,
                                                    userSession: router.userSession), onTakingSurvey: {
                    showSuccessSurvey = true
                }, onGetListSurveyError: {
                    self.router.navigateToLogin()
                    self.router.userSession.clearSession()
                }, didLogoutAction: {
                    self.router.navigateToLogin()
                    self.router.userSession.clearSession()
                })
                .environmentObject(router)
            case .forgotPassword:
                ForgotPassword(onDismiss: {
                    router.navigateToLogin()
                })
            default:
                EmptyView()
            }
        }
        .fullScreenCover(isPresented: $showSuccessSurvey) {
            SucessSurvey(onDismiss: {
                showSuccessSurvey = false
            })
        }
        .alert(isPresented: $router.showAlert) {
          Alert(
            title: Text("Notification"),
            message: Text(router.alertMessage),
            dismissButton: .default(Text("OK"))
          )
        }
    }
}
