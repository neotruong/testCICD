//
//  Auth+EndPoint.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/1/24.
//

import Foundation

final class AuthEndpoint: EndPointProtocol {
    
    typealias EndPointType = EndpointType
    
    enum EndpointType: String, CaseIterable {
        case login = "oauth/token"
        case forgotPassword = "password"
    }
    
    func getEndPoint(type: EndPointType) -> String {
        return type.rawValue
    }
    
}
