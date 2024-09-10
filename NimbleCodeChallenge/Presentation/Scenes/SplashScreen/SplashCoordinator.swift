//
//  SplashCoordinator.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/3/24.
//

import SwiftUI
import Stinsen

final class SplashCoordinator: NavigationCoordinatable {
    var stack = NavigationStack(initial: \SplashCoordinator.start)
    
    @Root var start = makePlash
    @Route(.push) var routeToLogin = makeLogin
    
    @ViewBuilder
    func makeLogin() -> some View {
        let authRepo = AuthRepository()
        let loginUseCase = LoginUseCase(authRepo: authRepo)
        let viewModel = AuthViewModel(loginUseCase: loginUseCase)
        NavigationViewCoordinator(UnauthenticatedCoordinator())
    }
    
    @ViewBuilder
    func makePlash() -> some View {
        SplashScreen()
    }
    
}
