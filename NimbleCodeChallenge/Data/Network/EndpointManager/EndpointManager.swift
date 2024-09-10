//
//  EndpointManager.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/1/24.
//

import Foundation

protocol EndPointProtocol {
    associatedtype EndPointType: RawRepresentable where EndPointType.RawValue == String
    func getEndPoint(type: EndPointType) -> String
}

protocol EndPointMangerProtocol {
    func getEndPoints<T: EndPointProtocol>(for service: T, type: T.EndPointType) -> String
}

final class EndpointsManager: EndPointMangerProtocol {
    
    static let shared = EndpointsManager()
    
    private init() {}
    
    private let baseDomain = ConfigHelper.baseURL
    private let apiVersion = ConfigHelper.apiVersion
    
    func getEndPoints<T: EndPointProtocol>(for service: T, type: T.EndPointType) -> String {
        return baseDomain + apiVersion + service.getEndPoint(type: type)
    }
}
