//
//  AuthScreen.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 8/29/24.
//

import SwiftUI
import IQKeyboardManagerSwift
import Combine

struct AuthScreen: View {
    @ObservedObject var input: AuthViewModel.Input
    @ObservedObject var output: AuthViewModel.Output
    @EnvironmentObject var router: MainRouterViewModel

    private var cancelBag: CancelBag = CancelBag()
    var onLogin: (() -> Void)?
    var onForgotPassword: (() -> Void)?

    init(viewModel: AuthViewModel, onLogin: (() -> Void)? = nil, onForgotPassword: (() -> Void)? = nil) {
        let input = AuthViewModel.Input()
        self.output = viewModel.transform(input)
        self.input = input
        self.onLogin = onLogin
        self.onForgotPassword = onForgotPassword
    }

    var body: some View {
        GeometryReader { _ in
            ZStack {
                CommonBackground()
                VStack {
                    LogoView(size: 1.0, opacity: 1.0)
                        .padding(.top, 108)

                    VStack {
                        MTextField(placeholder: MString.Auth.email,
                                   text: $input.emailTextField)
                            .frame(height: 56)
                            .padding(.bottom, 16)

                        MTextField(placeholder: MString.Auth.password,
                                   text: $input.passwordTextField,
                                   tralingText: MString.Auth.forgot,
                                   trailingButtonAction: navToForgotPassword,
                                   isSecure: true)
                            .frame(height: 56)
                            .padding(.bottom, 16)

                        MButton(title: MString.Auth.login,
                                buttonAction: {
                                    input.loginButtonTrigger.send(())
                                }, isEnabled: output.isLoginEnabled)
                            .disabled(!output.isLoginEnabled)
                            .frame(height: 50)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 113)

                    Spacer()
                }
                .onAppear {
                    router.userSession.clearSession()
                    outputTransform()
                }
                .onReceive(output.onLoginSuccess) { _ in
                    self.navToHomeScreen()
                }
                .onReceive(output.onError) { message in
                    self.router.triggerAlert(message: message)
                }
            }

            if output.isLoading {
                LoadingOverlayView()
            }
        }
        .hideNavigationBar()
    }

    private func navToForgotPassword() {
        self.onForgotPassword?()
    }

    private func navToHomeScreen() {
        self.onLogin?()
    }

    private func outputTransform() {
        output.onLoginSuccess
            .handleEvents(receiveCancel: {
                print("The refresh action was canceled.")
            })
            .sink(receiveValue: {
                self.navToHomeScreen()
            })
            .store(in: cancelBag)

        output.onError
            .sink(receiveValue: { message in
                self.router.triggerAlert(message: message)
            })
            .store(in: cancelBag)
    }
}
