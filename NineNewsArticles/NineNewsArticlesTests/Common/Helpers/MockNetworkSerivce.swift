//
//  MockNetworkSerivceArticleResponse.swift
//  NineNewsArticlesTests
//
//  Created by Abdullah Al-Ashi on 3/2/2023.
//

import XCTest

@testable import NineNewsArticles

class MockNetworkSerivce: NetworkServiceProtocol {
    
    var success: Bool = true
    var stubs: Any?
    private(set) var calledCount: Int = 0
    
    func get<Model>(url: URL, completion: @escaping NetworkCompletionHandler<Model>) where Model : Codable {
        calledCount += 1
        switch success {
        case true:
            completion(.success(stubs as? Model))
        case false:
            completion(.failure(HTTPError.invalidResponse))
        }
    }
}

public enum HTTPError: Error {
    case invalidResponse
}
