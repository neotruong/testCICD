//
//  SplashScreen.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 8/29/24.
//

import SwiftUI

struct SplashScreen: View {
    @State private var showImage = false
    @State private var imageSize = 0.3
    @State private var imageOpacity = 0.5

    private let delayLogoTime = 0.63
    @EnvironmentObject var router: MainRouterViewModel

    var onFinishAnimation: (() -> Void)?

    var body: some View {
        NavigationView {
            ZStack {
                Image(Assets.Images.splashScreen)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(.all)

                if showImage {
                    LogoView(size: imageSize, opacity: imageOpacity)
                        .onAppear {
                            animateLogo()
                        }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delayLogoTime) {
                    showImage = true
                }
            }
            .hideNavigationBar()
        }
    }

    private func animateLogo() {
        withAnimation(.easeIn(duration: delayLogoTime)) {
            self.imageSize = 1.0
            self.imageOpacity = 1.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + delayLogoTime) {
            self.onFinishAnimation?()
        }
    }
}

#Preview {
    SplashScreen()
}
