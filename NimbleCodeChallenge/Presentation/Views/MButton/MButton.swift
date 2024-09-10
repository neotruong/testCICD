//
//  MButton.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 8/29/24.
//

import SwiftUI

struct MButton: View {
    var title: String
    var buttonAction: (() -> Void)?
    var isEnabled: Bool = true

    init(title: String, buttonAction: ( () -> Void)? = nil, isEnabled: Bool = true) {
        self.title = title
        self.buttonAction = buttonAction
        self.isEnabled = isEnabled
    }

    var body: some View {
        Button {
            self.buttonAction?()
        } label: {
            Text(title)
                .frame(maxWidth: .infinity)
                .foregroundColor(buttonForegroundColor())
                .disabled(!isEnabled)
                .font(MFont.customFont(.bold, size: 17))

        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(ThemeManager.shared.color.primaryWhite)
        .cornerRadius(100)
    }

    private func buttonForegroundColor() -> Color {
        return isEnabled ? ThemeManager.shared.color.enableTextButton : ThemeManager.shared.color.disableTextButton
    }
}
