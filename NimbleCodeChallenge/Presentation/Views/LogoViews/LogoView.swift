//
//  LogoView.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 8/28/24.
//

import SwiftUI

struct LogoView: View {
    let imageName: String = Assets.Images.logo
    let size: CGFloat
    let opacity: Double
    
    var body: some View {
        Image(imageName)
            .clipped()
            .scaleEffect(size)
            .opacity(opacity)
    }
}
