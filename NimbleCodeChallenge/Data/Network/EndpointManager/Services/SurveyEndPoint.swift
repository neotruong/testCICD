//
//  Auth+EndPoint.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/1/24.
//

import Foundation

final class SurveyEndPoint: EndPointProtocol {
    
    typealias EndPointType = EndpointType
    
    enum EndpointType: String, CaseIterable {
        case getList = "surveys"
    }
    
    func getEndPoint(type: EndPointType) -> String {
        return type.rawValue
    }
    
}
