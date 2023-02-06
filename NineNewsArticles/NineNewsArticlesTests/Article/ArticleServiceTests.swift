//
//  ArticleServiceTests.swift
//  NineNewsArticlesTests
//
//  Created by Abdullah Al-Ashi on 3/2/2023.
//

import XCTest
@testable import NineNewsArticles

class ArticleServiceTests: XCTestCase {
    
    private var networkService: MockNetworkSerivce!
    private var articleService: ArticleServiceProtocol!

    override func setUpWithError() throws {
        networkService = MockNetworkSerivce()
        articleService = ArticleService(networkService: networkService)
    }

    override func tearDownWithError() throws {
        networkService = nil
        articleService = nil
    }

    func testGetArticlesSuccess() throws {
        networkService.stubs = ArticleResponse.mock()
        XCTAssertEqual(networkService.calledCount, 0)
        let expectation = XCTestExpectation(description: "api call success")
        articleService.getArticles { [weak self] articles, error in
            XCTAssertEqual(self?.networkService.calledCount, 1)
            XCTAssertNil(error)
            XCTAssertNotNil(articles)
            XCTAssertEqual(articles?.count, 1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testGetArticlesFail() throws {
        networkService.success = false
        XCTAssertEqual(networkService.calledCount, 0)
        let expectation = XCTestExpectation(description: "api call fail")
        articleService.getArticles { [weak self] articles, error in
            XCTAssertEqual(self?.networkService.calledCount, 1)
            XCTAssertNotNil(error)
            XCTAssertNil(articles)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }

}

fileprivate extension ArticleResponse {
    static func mock(articleResponse: ArticleResponse = .init(articles: [.mock()])) -> Self {
        return .init(articles: articleResponse.articles)
    }
}
