//
//  Coordinator.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/3/24.
//

import Foundation
import SwiftUI

protocol Coordinator: ObservableObject {
    associatedtype Screen
    var currentScreen: Screen? { get set }
    func navigate(to screen: Screen)
    func pop()
}
