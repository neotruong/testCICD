//
//  SurveyRequestDTO.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/3/24.
//

import Foundation

protocol BaseEncodable: Encodable {
    func toDictionary() -> [String: Any]?
}

extension BaseEncodable {
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return (try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed))
            .flatMap { $0 as? [String: Any] }
    }
}

struct SurveyRequestDTO: BaseEncodable {
    let token: String
    let pageNumber: Int = 1
    let pageSize: Int = 10
}
