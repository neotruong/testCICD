//
//  SplashViewModel.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/3/24.
//

import Foundation
import Stinsen
import Combine

final class SplashViewModel: BaseViewModel {
    
    class Input: ObservableObject {
        let routerTriggerAction: PassthroughSubject<Void, Never>
        
        init(routerTriggerAction: PassthroughSubject<Void, Never> = .init()) {
            self.routerTriggerAction = routerTriggerAction
        }
    }
    
    class Output: ObservableObject {
        
    }
    
    func transform(_ input: Input) -> Output {
        
        input.routerTriggerAction.sink(receiveValue: { [weak self] in
           print("test")
        })
        .store(in: CancelBag())
        
        
        return Output()
    }
}
