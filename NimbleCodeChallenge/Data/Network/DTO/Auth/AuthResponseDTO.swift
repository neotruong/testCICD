//
//  AuthResponseDTO.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/2/24.
//

import Foundation

protocol BaseDTO: Codable {

}

struct AuthResponseDTO: BaseDTO {
    let data: TokenDataDTO
}

struct TokenDataDTO: BaseDTO {
    let id: String
    let type: String
    let attributes: TokenAttributesDTO
}

struct TokenAttributesDTO: BaseDTO {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let refreshToken: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case createdAt = "created_at"
    }
}
