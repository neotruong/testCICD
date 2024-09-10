//
//  KeychainHelper.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/3/24.
//
import Foundation
import KeychainAccess

protocol KeyChainProtocol {
    func storeData(keyValue: (KeyChainType, Any))
    func getData(key: KeyChainType) -> String
    func clearKey(key: KeyChainType) // Clears a specific key
    func clearAllKeys() // Clears all keys
}

enum KeyChainType: String {
    case refreshToken
    case expiresIn
    case createdAt
    case accessToken
}

final class KeychainHelper: KeyChainProtocol {

    private let serviceName = "tphgphuc.NimbleCodeChallenge"
    private let keyChain: Keychain

    init() {
        keyChain = Keychain(service: serviceName)
    }

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
            print("Unsupported type, cannot store in Keychain")
            return
        }

        keyChain[keyValue.0.rawValue] = stringValue
    }

    func getData(key: KeyChainType) -> String {
        return keyChain[key.rawValue] ?? ""
    }

    func clearKey(key: KeyChainType) {
        do {
            try keyChain.remove(key.rawValue)
        } catch let error {
            print("Error removing \(key.rawValue) from Keychain: \(error)")
        }
    }

    func clearAllKeys() {
        do {
            try keyChain.removeAll()
        } catch let error {
            print("Error removing all keys from Keychain: \(error)")
        }
    }
}
