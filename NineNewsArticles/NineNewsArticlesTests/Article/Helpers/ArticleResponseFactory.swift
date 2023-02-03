//
//  ArticleResponseFactory.swift
//  NineNewsArticlesTests
//
//  Created by Abdullah Al-Ashi on 3/2/2023.
//

import Foundation
@testable import NineNewsArticles

class ArticleResponseFactory {
    enum ArticleFactoryResponseError: Error {
        case unableToLoadResponse
        case unableToLoadData
    }
    
    static func articleResponse() throws -> ArticleResponse {
        let testBundle = Bundle(for: ArticleResponseFactory.self)
        guard let path = testBundle.path(forResource: "nineNews-articles-response-success", ofType: "json") else {
            assertionFailure()
            throw ArticleFactoryResponseError.unableToLoadResponse
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let response = try JSONDecoder().decode(ArticleResponse.self, from: data)
            return response
        } catch {
            throw ArticleFactoryResponseError.unableToLoadResponse
        }
    }
    
    static func articleData() throws -> Data {
        let testBundle = Bundle(for: ArticleResponseFactory.self)
        guard let path = testBundle.path(forResource: "nineNews-articles-response-success", ofType: "json") else {
            assertionFailure()
            throw ArticleFactoryResponseError.unableToLoadResponse
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let json = try JSONDecoder().decode(ArticleResponse.self, from: data)
            print(json)
            return data
        } catch {
            print(error)
            throw ArticleFactoryResponseError.unableToLoadData
        }
    }
}
