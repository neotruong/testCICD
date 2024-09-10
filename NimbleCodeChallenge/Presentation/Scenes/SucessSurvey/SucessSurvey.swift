//
//  SucessSurvey.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 8/30/24.
//

import SwiftUI
import Lottie

struct SucessSurvey: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isTextVisible = false
    var onDismiss: (() -> Void)?
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center, spacing: 10) {
                LottieView(filename: "sucessAnim")
                    .frame(width: 200, height: 200)
                MText(text: MString.SucessSurvey.sucessDes, 
                      font: MFont.customFont(.bold, size: 28),
                      color: ThemeManager.shared.color.primaryWhite)
                    .padding(20)
                    .multilineTextAlignment(.center)
                    .opacity(isTextVisible ? 1 : 0)
                    .scaleEffect(isTextVisible ? 1 : 0.8)
                    .animation(.easeOut(duration: 2), value: isTextVisible)
            }
        }
        .onAppear {
            withAnimation {
                isTextVisible = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.presentationMode.wrappedValue.dismiss()
                self.onDismiss?()
            }
        }
        .hideNavigationBar()
    }
}

#Preview {
    SucessSurvey()
}

#Preview {
    SucessSurvey()
}
