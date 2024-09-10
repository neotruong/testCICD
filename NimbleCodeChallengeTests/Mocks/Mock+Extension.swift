//
//  Mock+Extension.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/5/24.
//

import Foundation


extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from fileName: String) -> T? {
        guard let url = self.url(forResource: fileName, withExtension: "json") else {
            fatalError("Failed to locate \(fileName) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(fileName) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let decodedObject = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(fileName) from bundle.")
        }

        return decodedObject
    }
}
