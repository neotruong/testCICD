import Foundation

enum AuthGrantType: String, BaseEncodable {
    case password = "password"
    case refreshToken = "refresh_token"
}

struct AuthRequestDTO: BaseEncodable {
    let grantType: AuthGrantType
    let email: String?
    let password: String?
    let clientId: String
    let clientSecret: String
    
    enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case email
        case password
        case clientId = "client_id"
        case clientSecret = "client_secret"
    }
}

struct AuthRefreshTokenDTO: BaseEncodable {
    let grantType: AuthGrantType
    let clientId: String?
    let clientSecret: String

    enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case clientId = "client_id"
        case clientSecret = "client_secret"
    }
}
