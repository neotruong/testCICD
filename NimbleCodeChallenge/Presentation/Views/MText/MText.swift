//
//  MText.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 8/30/24.
//

import SwiftUI

struct MText: View {
    var text: String
    var font: Font = .system(size: 16, weight: .regular, design: .default)
    var color: Color = .primary
    var padding: CGFloat = 0
    var backgroundColor: Color = .clear
    var cornerRadius: CGFloat = 0

    var body: some View {
        Text(text)
            .font(font)
            .foregroundColor(color)
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
    }
}
