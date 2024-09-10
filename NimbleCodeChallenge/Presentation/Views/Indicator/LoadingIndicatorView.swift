//
//  Indicator.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/2/24.
//

import Foundation
import SwiftUI

struct LoadingOverlayView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 10)
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2.0)
            }
            .padding(40)
            .background(Color.white.opacity(0.5))
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
        }
    }
}
