//
//  ConfigHelper.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/3/24.
//

import Foundation

class ConfigHelper {
    
    enum ConfigKey: String {
        case baseURL = "SERVER_BASE_URL"
        case clientSecrect = "CLIENT_SECRET"
        case clientID = "CLIENT_ID"
        case apiVersion = "API_VERSION"
    }
    
    static var baseURL: String {
        return self.getConfigValue(key: .baseURL)
    }
    
    static var apiVersion: String {
        return self.getConfigValue(key: .apiVersion)
    }

    static var clientSecret: String {
        return self.getConfigValue(key: .clientSecrect)
    }
    
    static var clientId: String {
        return self.getConfigValue(key: .clientID)
    }

    static func getConfigValue(key: ConfigKey, targetBundle: Bundle = Bundle.main) -> String {
        guard let value = targetBundle.object(forInfoDictionaryKey: key.rawValue) as? String else {
            return ""
        }
        return value
    }

}
