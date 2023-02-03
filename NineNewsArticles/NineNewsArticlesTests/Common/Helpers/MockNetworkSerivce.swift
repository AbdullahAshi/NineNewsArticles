//
//  MockNetworkSerivceArticleResponse.swift
//  NineNewsArticlesTests
//
//  Created by Abdullah Al-Ashi on 3/2/2023.
//

import XCTest

@testable import NineNewsArticles

class MockNetworkSerivceArticleResponse: NetworkServiceProtocol {
    
    var success: Bool
    
    init(success: Bool) {
        self.success = success
    }
    
    func get<Model>(url: URL, completion: @escaping (Model?, Error?) -> Void) where Model : Codable {
        switch success {
        case true:
            let articleListResponse = try! ArticleResponseFactory.articleResponse() as? Model
            completion(articleListResponse, nil)
        case false:
            completion(nil, ArticleResponseFactory.ArticleFactoryResponseError.unableToLoadResponse)
        }
    }
}
