//
//  ArticleViewModelTests.swift
//  NineNewsArticlesTests
//
//  Created by Abdullah Al-Ashi on 4/2/2023.
//

import XCTest

@testable import NineNewsArticles

class ArticleViewModelTests: XCTestCase {
    
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
    
    
    
    func testDataSourceProtocolConformance() {
        articleSerivce.articles = [.mock(id: 0), .mock(id: 1), .mock(id: 0)]
        articleViewModel.loadData()
        XCTAssertEqual(articleViewModel.numberOfItems(inSection: 0), 3)
        
        let article = try! XCTUnwrap(articleViewModel.getArticle(at: 1))
        XCTAssertEqual(article.id, 1)
        
    }
}
