//
//  ForgotPassword.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 8/29/24.
//

import SwiftUI

struct ForgotPassword: View {
    @State private var email = ""
    var onDismiss: (() -> Void)?

    var body: some View {
        GeometryReader { _ in
            ZStack {
                CommonBackground()
                VStack {
                    HStack {
                        Button(action: {
                            self.onDismiss?()
                        }) {
                            Image(Assets.Images.backArrow)
                        }
                        Spacer()
                    }
                    .padding(.top, 13)
                    .padding(.horizontal, 22)
                    Group {
                        LogoView(size: 1.0, opacity: 1.0)
                            .padding(.top, 108)
                            .padding(.bottom, 24)
                        MText(text: MString.Forgot.description,
                              color: ThemeManager.shared.color.paddingButtonWhite)
                        .padding(.horizontal, 24)
                        .multilineTextAlignment(.center)
                    }

                    VStack( alignment: .leading, spacing: 20) {
                        MTextField(placeholder: MString.Auth.email,
                                   text: $email)
                        .frame(height: 56)
                        MButton(title: MString.Forgot.reset)
                            .frame(height: 50)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 86)
                    Spacer()
                }
            }
        }
        .hideNavigationBar()
    }
}

#Preview {
    ForgotPassword()
}
