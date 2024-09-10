//
//  HomeCardView.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 8/30/24.
//

import SwiftUI
struct HomeCardView: View {
    var dateText: String
    var titleText: String
    var imageName: String

    var onAvatarTap: (() -> Void)?

    init(dateText: String, titleText: String, imageName: String, onAvatarTap: (() -> Void)? = nil) {
        self.dateText = dateText
        self.titleText = titleText
        self.imageName = imageName
        self.onAvatarTap = onAvatarTap
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                MText(text: dateText,
                      font: MFont.customFont(.bold, size: 13),
                      color: ThemeManager.shared.color.primaryWhite)
                .padding(.bottom, 4)
                
                MText(text: titleText,
                      font: MFont.customFont(.bold, size: 34),
                      color: ThemeManager.shared.color.primaryWhite)
            }

            Spacer()
            Circle()
                .fill(.yellow)
                .frame(width: 48, height: 48)
                .overlay(
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                )
                .onTapGesture {
                    self.onAvatarTap?()
                }
        }
        .padding(20)
        .background(.white.opacity(0.15))
        .cornerRadius(20)
    }
}
