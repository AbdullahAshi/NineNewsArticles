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
    
    func get<Model>(url: URL, completion: @escaping (Model?, Error?) -> Void) where Model : Codable {
        calledCount += 1
        switch success {
        case true:
            completion(stubs as? Model, nil)
        case false:
            completion(nil, HTTPError.invalidResponse)
        }
    }
}

public enum HTTPError: Error {
    case invalidResponse
}
