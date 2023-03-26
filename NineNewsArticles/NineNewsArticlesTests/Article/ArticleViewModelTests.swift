//
//  ArticleViewModelTests.swift
//  NineNewsArticlesTests
//
//  Created by Abdullah Al-Ashi on 4/2/2023.
//

import XCTest

@testable import NineNewsArticles
import SnapshotTesting

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
    
    func testStateMachine() {
        let viewModel = articleViewModel as! ArticleViewModel
        XCTAssertEqual(viewModel.state, .initial)
        
        articleSerivce.articles = []
        articleViewModel.loadData()
        XCTAssertEqual(viewModel.articles?.count, 0)
        XCTAssertEqual(viewModel.state, .loadedEmpty)
        
        articleSerivce.articles = [.mock(id: 0), .mock(id: 1), .mock(id: 0)]
        articleViewModel.loadData()
        XCTAssertEqual(viewModel.articles?.count, 3)
        XCTAssertEqual(viewModel.state, .loaded)
        
        articleSerivce.success = false
        articleViewModel.loadData()
        XCTAssertEqual(viewModel.state, .loadedError(error: MockArticleService.ServiceError.invalidResponse))
    }
    
    func testLoadDataCallingService() {
        XCTAssertEqual(articleSerivce.calledCount, 0)
        articleSerivce.articles = [.mock(id: 0), .mock(id: 1), .mock(id: 0)]
        articleViewModel.loadData()
        XCTAssertEqual(articleSerivce.calledCount, 1)
    }
    
    func testDataSourceProtocolConformance() throws {
        XCTAssertNil(articleViewModel.getArticle(at: 0))
        articleSerivce.articles = [.mock(id: 0), .mock(id: 1), .mock(id: 0)]
        articleViewModel.loadData()
        XCTAssertEqual(articleViewModel.numberOfItems(inSection: 0), 3)
        
        let article = try? XCTUnwrap(articleViewModel.getArticle(at: 1))
        XCTAssertEqual(article?.id, 1)
        
    }
    
    func testScreen() throws {
        let articleCollectionViewController = try XCTUnwrap(UIStoryboard.init(name: ArticleCollectionViewController.storyboardIdentifier, bundle: nil).instantiateViewController(withIdentifier: ArticleCollectionViewController.identifier) as? ArticleCollectionViewController)
        let mockViewModel = MockArticleViewModel()
        mockViewModel.loadData()
        articleCollectionViewController.setup(viewModel: mockViewModel)

        assertVCSnapshot(articleCollectionViewController)
        
        //// assertVCSnapshot(articleCollectionViewController, waitDuration: 10.0) //this will make the test work for real urls
        
        //// another way to make the wait
//        let exp = expectation(description: "Test after 10 seconds")
//        let result = XCTWaiter.wait(for: [exp], timeout: 10.0)
//        if result == XCTWaiter.Result.timedOut {
//            assertVCSnapshot(articleCollectionViewController)
//        } else {
//            XCTFail("Delay interrupted")
//        }
    }
}


class MockArticleViewModel: ArticleViewModelProtocol, ViewModelCollectionDataSourceProtocol {
    var callback: ((ArticleViewModel.State) -> Void)? = nil
    
    private(set) var articles: [Article]? = []
    
    private(set) var state: ArticleViewModel.State = .initial {
        didSet {
            callback?(state)
        }
    }
    
    init() {
    }
    
    func loadData() {
        self.articles = [Article.mock(id: 1), Article.mock(id: 2), Article.mock(id: 3)]
        self.state = .loaded
    }
    
    func smallestImageURL(article: Article) -> String? {
        return article.relatedImages.min{ $0.size < $1.size }?.url
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    func getArticle(at index: Int) -> Article? {
        guard let articles = articles, index < articles.count else {
            return nil
        }
        return articles[index]
    }
    
    func getCellViewModelForArticle(at index: Int) -> NineNewsArticles.NNewsCollectionViewCellViewModel? {
        guard let article = getArticle(at: index) else {
            return nil
        }
        return NNewsCollectionViewCellViewModel(headLine: article.headline, abstract: article.theAbstract, signature: article.byLine , imageUrl: nil, fallBackImageName: "mock-article-image")
    }
}
