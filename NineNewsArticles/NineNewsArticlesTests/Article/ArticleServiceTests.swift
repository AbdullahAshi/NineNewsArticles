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

fileprivate extension Article {
    static func mock(
        article: Article = .init(id: 0,
                                 url: "https://www.9news.com/article/test",
                                 headline: "headLine test",
                                 theAbstract: "the abstract test",
                                 byLine: "the author test",
                                 relatedImages: [.mock()],
                                 timeStamp: 1031731070)) -> Self {
        return .init(id: article.id,
                     url: article.url,
                     headline: article.headline,
                     theAbstract: article.theAbstract,
                     byLine: article.byLine,
                     relatedImages: article.relatedImages,
                     timeStamp: article.timeStamp)
    }
}

fileprivate extension AssetRelatedImage {
    static func mock(assetRelatedImage: AssetRelatedImage = .init(id: 1031731070,
                                                                  url: "https://www.fairfaxstatic.com.au/content/dam/images/h/2/9/k/s/e/image.related.afrArticleLead.1536x1010.p5ch3u.13zzqx.png/1675404460646.jpg",
                                                                  width: 1536,
                                                                  height: 1122,
                                                                  xLarge2X: nil,
                                                                  large2X: nil,
                                                                  timeStamp: 1675060332000,
                                                                  xLarge: nil,
                                                                  large: nil,
                                                                  thumbnail2X: nil,
                                                                  thumbnail: nil)) -> Self {
        return .init(id: assetRelatedImage.id,
                     url: assetRelatedImage.url,
                     width: assetRelatedImage.width,
                     height: assetRelatedImage.height,
                     xLarge2X: assetRelatedImage.xLarge2X,
                     large2X: assetRelatedImage.large2X,
                     timeStamp: assetRelatedImage.timeStamp,
                     xLarge: assetRelatedImage.xLarge,
                     large: assetRelatedImage.large,
                     thumbnail2X: assetRelatedImage.thumbnail2X,
                     thumbnail: assetRelatedImage.thumbnail)
    }
}
