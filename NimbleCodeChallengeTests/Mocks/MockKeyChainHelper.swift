//
//  MockKeyChainHelper.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/4/24.
//

import XCTest
import Combine
@testable import NimbleCodeChallenge

final class MockKeychainHelper: KeyChainProtocol {
    private var storage: [KeyChainType: String] = [:]

    func storeData(keyValue: (KeyChainType, Any)) {
        let stringValue: String

        switch keyValue.1 {
        case let value as String:
            stringValue = value
        case let value as Int:
            stringValue = String(value)
        case let value as Double:
            stringValue = String(value)
        case let value as Bool:
            stringValue = String(value)
        default:
            return
        }

        storage[keyValue.0] = stringValue
    }

    func getData(key: KeyChainType) -> String {
        return storage[key] ?? ""
    }

    func clearKey(key: KeyChainType) {
        storage.removeValue(forKey: key)
    }

    func clearAllKeys() {
        storage.removeAll()
    }
}
