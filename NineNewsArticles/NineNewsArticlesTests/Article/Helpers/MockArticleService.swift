//
//  MockArticleService.swift
//  NineNewsArticlesTests
//
//  Created by Abdullah Al-Ashi on 4/2/2023.
//

import Foundation

@testable import NineNewsArticles

class MockArticleService: ArticleServiceProtocol {
    
    enum ServiceError: Error {
        case invalidResponse
    }
    
    var success: Bool = true
    var articles: [Article] = []
    private(set) var calledCount: Int = 0
    
    func getArticles(completion: @escaping ArticleListCompletionHandler) {
        calledCount += 1
        switch success {
        case true:
            completion(articles, nil)
        case false:
            completion(nil, ServiceError.invalidResponse)
        }
    }
}
