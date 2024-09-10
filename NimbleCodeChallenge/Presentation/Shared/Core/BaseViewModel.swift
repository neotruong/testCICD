//
//  BaseViewModel.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/2/24.
//

import Foundation

protocol BaseViewModel: ObservableObject {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
