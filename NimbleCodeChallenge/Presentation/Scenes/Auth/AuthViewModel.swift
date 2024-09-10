//
//  AuthViewModel.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/2/24.
//

import Foundation
import Combine

extension AuthViewModel {
    class Input: ObservableObject {
        let loginButtonTrigger: PassthroughSubject<Void, Never>
        let forgotPasswordTrigger: PassthroughSubject<Void, Never>
        
        @Published var emailTextField: String = ""
        @Published var passwordTextField: String = ""
        
        init() {
            self.loginButtonTrigger = .init()
            self.forgotPasswordTrigger = .init()
        }
    }
    
    class Output: ObservableObject {
        @Published var isLoading = false
        @Published var isLoginEnabled = false

        let onLoginSuccess: PassthroughSubject<Void, Never>
        let onError: PassthroughSubject<String, Never>

        init(isLoading: Bool = false, isLoginEnabled: Bool = false, onLoginSuccess: PassthroughSubject<Void, Never>) {
            self.isLoading = isLoading
            self.isLoginEnabled = isLoginEnabled
            self.onLoginSuccess = onLoginSuccess
            self.onError = .init()
        }
        
    }
}

final class AuthViewModel: BaseViewModel {
    
    let loginUseCase: LoginUseCaseProtocol
    private let cancelBag = CancelBag()
    let userSession: UserSessionProtocol

    init(loginUseCase: LoginUseCaseProtocol, userSession: UserSessionProtocol) {
        self.userSession = userSession
        self.loginUseCase = loginUseCase
    }
    
    func transform(_ input: Input) -> Output {
        let onLoginSuccess: PassthroughSubject<Void, Never> = .init()
        let output = Output(onLoginSuccess: onLoginSuccess)
        
        let inputValidation = validateInputPublisher(input: input)
        
        inputValidation
                  .assign(to: \.isLoginEnabled, on: output)
                  .store(in: cancelBag)
        
        input.loginButtonTrigger
            .combineLatest(inputValidation)
            .filter { _, isValid in isValid }
            .map { _ in
                self.loginUseCase.loginWithPassword(email: input.emailTextField, password: input.passwordTextField)
                    .handleEvents(receiveSubscription: { _ in
                        output.isLoading = true
                    }, receiveCompletion: { _ in
                        output.isLoading = false
                    }, receiveCancel: {
                        output.isLoading = false
                    })
                    .asDriver()
            }
            .switchToLatest()
            .sink(receiveValue: { response in
                switch response {
                case .success(_):
                    onLoginSuccess.send(())
                case .failure(let error):
                    output.onError.send(error.localizedDescription)
                }
            })
            .store(in: cancelBag)
        
        return output
    }
    
     private func validateInputPublisher(input: Input) -> AnyPublisher<Bool, Never> {
         Publishers.CombineLatest(input.$emailTextField, input.$passwordTextField)
             .map { [unowned self] email, password in
                 self.loginUseCase.validateEmail(email: email) && self.loginUseCase.validatePassword(password: password)
             }
             .eraseToAnyPublisher()
     }
}
