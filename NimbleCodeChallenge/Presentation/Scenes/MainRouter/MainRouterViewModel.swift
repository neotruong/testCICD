//
//  MainViewModel.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/4/24.
//

import SwiftUI
import Combine

class MainRouterViewModel: ObservableObject {
    @Published var currentPage: Page = .splash
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    let userSession: UserSession

    let onRefreshTokenError: PassthroughSubject<Error, Never> = .init()

    init(userSession: UserSession) {
        self.userSession = userSession
    }

    enum Page {
        case splash
        case login
        case home
        case forgotPassword
        case successSurvey
    }

    func transform() {
        userSession.onRefershTokenError.sink(receiveValue: { error in
            self.triggerAlert(message: error.localizedDescription)
            self.currentPage = .login
            self.userSession.clearSession()
        })
        .store(in: CancelBag())
    }

    func navigateToLogin() {
        self.currentPage = .login
    }

    func navigateToHome() {
        self.currentPage = .home
    }

    func navigateToForgotPassword() {
        self.currentPage = .forgotPassword
    }

    func navigateToSuccessSurvey() {
        self.currentPage = .successSurvey
    }

    func triggerAlert(message: String) {
        self.alertMessage = message
        self.showAlert = true
    }

    func handleSplashScreenCompletion() {
        if userSession.isLogin() && !userSession.isTokenExpired() {
            navigateToHome()
        } else {
            navigateToHome()
        }
    }
}
