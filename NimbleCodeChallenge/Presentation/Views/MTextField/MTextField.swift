//
//  MTextField.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 8/29/24.
//

import SwiftUI

struct MTextField: View {
    var placeholder: String
    @Binding var text: String
    var tralingText: String?
    var trailingButtonAction: (() -> Void)?
    var isSecure: Bool = false

    var body: some View {
        HStack {
            if isSecure {
                SecureField("", text: $text)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder).foregroundColor(ThemeManager.shared.color.textFieldPlaceholder)
                            .font(MFont.customFont(.regular, size: 17))
                    }
                    .font(MFont.customFont(.regular, size: 17))
                    .foregroundColor(ThemeManager.shared.color.primaryWhite)
                    .padding(20)

            } else {
                TextField("", text: $text)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder).foregroundColor(ThemeManager.shared.color.textFieldPlaceholder)
                            .font(MFont.customFont(.regular, size: 17))
                    }
                    .font(MFont.customFont(.regular, size: 17))
                    .foregroundColor(ThemeManager.shared.color.primaryWhite)
                    .padding(20)
            }

            Spacer()
            if let tralingText = tralingText {
                Button(tralingText, action: {
                    self.trailingButtonAction?()
                })
                .font(MFont.customFont(.regular, size: 17))
                .foregroundColor(ThemeManager.shared.color.primaryWhite)
                .padding(.trailing, 20)
            }
        } .background(ThemeManager.shared.color.secondaryWhite)
            .cornerRadius(100)
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(ThemeManager.shared.color.secondaryWhite, lineWidth: 1)
            )
    }
}
