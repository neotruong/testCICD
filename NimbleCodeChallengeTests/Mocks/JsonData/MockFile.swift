//
//  MockFile.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/5/24.
//

import Foundation

enum MockFile: String {
    case authResponse = "MockAuthResponse"
    case surveyResponse = "MockSurveyResponse"
}

class MockManager {

    static func loadJSON<T: Decodable>(from mockFile: MockFile, as type: T.Type) -> T? {
        let fileName = mockFile.rawValue

        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("Failed to locate \(fileName).json in bundle.")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Failed to decode \(fileName).json: \(error)")
            return nil
        }
    }
}
