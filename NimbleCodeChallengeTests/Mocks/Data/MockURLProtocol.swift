//
//  MockURLProtocol.swift
//  NimbleCodeChallengeTests
//
//  Created by Neo Truong on 9/6/24.
//

import Foundation
import Alamofire

extension Session {
    static func createMockSession(mockData: Data? = nil, mockError: Error? = nil) -> Session {
        // Set the mock response in MockURLProtocol
        MockURLProtocol.setMockResponse(mockData: mockData, mockError: mockError)

        // Configure the session to use the MockURLProtocol
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return Session(configuration: configuration)
    }
}


class MockURLProtocol: URLProtocol {
    private static var mockData: Data?
    private static var mockError: Error?

    // Function to set the mock data and error
    static func setMockResponse(mockData: Data?, mockError: Error?) {
        self.mockData = mockData
        self.mockError = mockError
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = MockURLProtocol.mockError {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else if let data = MockURLProtocol.mockData {
            self.client?.urlProtocol(self, didLoad: data)
        } else {
            self.client?.urlProtocol(self, didLoad: Data())
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
