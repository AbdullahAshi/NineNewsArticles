//
//  ArticleCollectionViewUITests.swift
//  NineNewsArticlesTests
//
//  Created by Abdullah Al-Ashi on 6/2/2023.
//

import XCTest

@testable import NineNewsArticles

class ArticleCollectionViewUITests: XCTestCase {
    
    private var articleViewModel: ArticleViewModelDataSourceProtocol!
    private var articleSerivce: MockArticleService!
    
    override func setUpWithError() throws {
        articleSerivce = MockArticleService()
        articleViewModel = ArticleViewModel(articleService: articleSerivce)
    }
    
    override func tearDownWithError() throws {
        articleSerivce = nil
        articleViewModel = nil
    }    
}
