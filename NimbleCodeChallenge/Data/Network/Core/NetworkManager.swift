//
//  NetworkManager.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/1/24.
//

import Foundation
import Alamofire
import Combine

protocol NetworkRepositoryProtocol {
    func request<T: BaseDTO>(_ url: String,
                               method: HTTPMethod,
                               parameters: Parameters?,
                               completion: @escaping (Result<T, NetworkError>) -> Void)
    func refreshToken(url: String,
                      method: HTTPMethod,
                      parameters: Parameters?,
                      completion: @escaping (Result<AuthResponseDTO, NetworkError>) -> Void)
    func trackProgress(for url: String) -> Progress?
}

enum NetworkError: Error {
    case afError(AFError)
    case customError(String)
    case unknownError

    var localizedDescription: String {
        switch self {
        case .afError(let error):
            return error.localizedDescription
        case .customError(let message):
            return message
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}

class NetworkSession {
    static func getSession() -> Session {
        return .default
    }
}
final class NetworkManager: NetworkRepositoryProtocol {

    private var session: Session = .default
    private var userSession: UserSessionRepoInterface?
    private var requestProgress: [String: Progress] = [:]

    static func shared() -> NetworkManager {
        return sharedDataManager
    }

    private static var sharedDataManager: NetworkManager = {
         let networkManager = NetworkManager()
         return networkManager
     }()

    private init() {}
    
    func configSession(session: Session) {
        self.session = session
    }

    func configUserSession(userSession: UserSessionRepoInterface?) {
        self.userSession = userSession
    }

    func trackProgress(for url: String) -> Progress? {
           return requestProgress[url]
    }

    func request<T: Decodable>(_ url: String,
                                           method: HTTPMethod,
                                           parameters: Parameters?,
                                           completion: @escaping (Result<T, NetworkError>) -> Void) {
        let request = session.request(url, method: method, parameters: parameters)

        request.downloadProgress { progress in
            self.requestProgress[url] = progress
        }

        request.validate()
            .responseDecodable(of: T.self) { response in
                self.requestProgress.removeValue(forKey: url)

                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let afError):
                    let customError: NetworkError
                    if let data = response.data {
                        if let json = try? JSONSerialization.jsonObject(with: data,
                                                                        options: .fragmentsAllowed) as? [String: Any],
                           let errors = json["errors"] as? [[String: Any]],
                           let errorDetail = errors.first?["detail"] as? String {
                            customError = .customError(errorDetail)
                        } else {
                            customError = .afError(afError)
                        }
                    } else if let underlyingError = afError.underlyingError {
                        customError = .customError(underlyingError.localizedDescription)
                    } else {
                        customError = .afError(afError)
                    }

                    completion(.failure(customError))
                }
            }
    }

    func refreshToken(url: String,
                      method: HTTPMethod,
                      parameters: Parameters?,
                      completion: @escaping (Result<AuthResponseDTO, NetworkError>) -> Void) {

        session.request(url, method: method, parameters: parameters)
            .downloadProgress { progress in
                self.requestProgress[url] = progress
            }
            .validate()
            .responseDecodable(of: AuthResponseDTO.self) { response in
                self.requestProgress.removeValue(forKey: url)

                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let afError):
                    let customError: NetworkError
                    if let data = response.data {
                        if let json = try? JSONSerialization.jsonObject(with: data,
                                                                        options: .fragmentsAllowed) as? [String: Any],
                           let errors = json["errors"] as? [[String: Any]],
                           let errorDetail = errors.first?["detail"] as? String {
                            customError = .customError(errorDetail)
                        } else {
                            customError = .afError(afError)
                        }
                    } else if let underlyingError = afError.underlyingError {
                        customError = .customError(underlyingError.localizedDescription)
                    } else {
                        customError = .afError(afError)
                    }
                    completion(.failure(customError))
                }
            }
    }
}
