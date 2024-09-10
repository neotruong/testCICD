//
//  Mcolor.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/3/24.
//

import Foundation
import SwiftUI

import Combine

protocol MTheme {
    var primaryWhite: Color { get }
    var secondaryWhite: Color { get }
    var paddingButtonWhite: Color { get }
    var enableTextButton: Color { get }
    var disableTextButton: Color { get }
    var pageControlSecondaryWhite: Color { get }
    var overlayBackground: Color { get }
    var textFieldPlaceholder: Color { get }
}

struct PrimaryTheme: MTheme {
    var pageControlSecondaryWhite: Color = .white.opacity(0.3)
    let primaryWhite = Color.white
    let secondaryWhite = Color.white.opacity(0.15)
    var enableTextButton = Color.black
    var disableTextButton = Color.gray
    var paddingButtonWhite: Color = .white.opacity(0.7)
    var overlayBackground: Color = Color.black.opacity(0.5)
    var textFieldPlaceholder: Color = .white.opacity(0.5)
}

class ThemeManager: ObservableObject {

    var color: MTheme
    
    static let shared = ThemeManager()
    
    private init() {
        color = PrimaryTheme()
    }
}
