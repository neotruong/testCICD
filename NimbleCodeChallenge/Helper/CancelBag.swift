//
//  CombineHelper.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/2/24.
//

import Foundation

import Combine

/// A container that holds a collection of cancellable subscriptions.
/// Useful for managing the lifecycle of multiple Combine subscriptions.
open class CancelBag {
    /// The set of cancellable subscriptions.
    public fileprivate(set) var subscriptions = Set<AnyCancellable>()
    
    /// Initializes a new instance of `CancelBag`.
    public init() {}
    
    /// Cancels all the subscriptions stored in the `CancelBag`.
    public func cancel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll(keepingCapacity: false)
    }
}

extension CancelBag: ObservableObject { }

extension AnyCancellable {
    /// Stores the cancellable subscription in the specified `CancelBag`.
    ///
    /// - Parameter cancelBag: The `CancelBag` in which to store the subscription.
    public func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}

extension Publisher {

    public func asDriver() -> AnyPublisher<Output, Never> {
        self.catch { _ in Empty() } // Ignore errors
            .receive(on: RunLoop.main) // Receive events on the main thread
            .share()
            .eraseToAnyPublisher() // Erase to AnyPublisher
    }

    public func asDriver(defaultValue: Output) -> AnyPublisher<Output, Never> {
        self.replaceError(with: defaultValue) // Replace errors with a default value
            .receive(on: RunLoop.main) // Receive events on the main thread
            .share() // Share the subscription among multiple subscribers with replay
            .eraseToAnyPublisher() // Erase to AnyPublisher
    }
}
