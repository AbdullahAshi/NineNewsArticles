//
//  ArticleService.swift
//  NineNewsArticles
//
//  Created by Abdullah Al-Ashi on 3/2/2023.
//

import Foundation

protocol ArticleServiceProtocol {
    func getArticles(completion: @escaping ArticleListCompletionHandler)
}

class ArticleService: ArticleServiceProtocol {
    
    private struct EndPoints {
        static let articlesListURL: URL = APIConstants.baseURL.appendingPathComponent("coding_test/13ZZQX/full")
    }
    
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func getArticles(completion: @escaping ArticleListCompletionHandler) {
        networkService.get(url: EndPoints.articlesListURL, completion: { (response: ArticleResponse?, error) in
            if error != nil {
                completion(nil, error)
            } else {
                completion(response?.articles, nil)
            }
        })
    }
}
