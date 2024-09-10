import SwiftUI
import Stinsen

final class AuthCoordinator: NavigationCoordinatable {
    var stack = NavigationStack(initial: \AuthCoordinator.start)
    
    @Root var start = makeLogin
    
    @ViewBuilder
    func makeLogin() -> some View {
        let authRepo = AuthRepository()
        let loginUseCase = LoginUseCase(authRepo: authRepo)
        let viewModel = AuthViewModel(loginUseCase: loginUseCase)
        AuthScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeHome() -> some View {
        let coordinator = HomeCoordinator()
        let surveyRepo = SurveyRepository()
        let homeUsecase = HomeUseCase(surveyRepo: surveyRepo)
        let viewModel = HomeViewModel(homeUseCase: homeUsecase)
        
        HomeScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
     func makeForgotPassword() -> some View {
         ForgotPassword()
     }
}
