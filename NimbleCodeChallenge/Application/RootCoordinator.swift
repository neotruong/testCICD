//
//  RootCoordinator.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/3/24.
//

import Foundation
import SwiftUI
import Stinsen

final class RootCoordinator: NavigationCoordinatable {
    var stack = NavigationStack(initial: \RootCoordinator.start)
    
    @Root var start = makeSplash
    
    @ViewBuilder
    func makeSplash() -> some View {
        SplashCoordinator().view()
    }
}
