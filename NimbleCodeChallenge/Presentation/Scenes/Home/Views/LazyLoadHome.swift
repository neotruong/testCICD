//
//  LazyLoadHome.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 8/30/24.
//

import Foundation
import SwiftUI

struct LazyLoadHome: View {
    var body: some View {
        VStack {
            HStack {
                Image("header_lzload")
                Spacer()
                Image("header_avatar_lzload")
            }
            .padding(.top, 60)
            .padding(.horizontal, 20)
            Spacer()
            VStack {
                HStack {
                    Image("header_bottom_lzload_1")
                    Spacer()
                }
                HStack {
                    Image("header_bottom_lzload_2")
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 60)
            
        }
        .shimmer()
        .background(.black)
        .hideNavigationBar()
    }
}

struct ShimmerViewModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [.clear, ThemeManager.shared.color.pageControlSecondaryWhite, .clear]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: phase, y: 0)
                .mask(content)
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 600
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerViewModifier())
    }
}
