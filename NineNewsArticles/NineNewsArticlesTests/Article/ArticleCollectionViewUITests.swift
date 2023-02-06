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
    
    func testArticleCollectionView() {
        
        guard let vc = UIStoryboard.init(name: "Article", bundle: nil).instantiateViewController(withIdentifier: ArticleCollectionViewController.storyboardIdentifier)
                as? ArticleCollectionViewController else {
                    XCTFail("couldn't instantiate ViewController")
                    return
                }
        
        let mockItem0 = Article.mock(id: 0)
        articleSerivce.articles = [mockItem0, .mock(id: 1), .mock(id: 0)]
        vc.setup(viewModel: articleViewModel)
        let _ = vc.view
        
        let actualCell = vc.collectionView(vc.collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as! NNewsCollectionViewCell
        XCTAssertEqual(actualCell.headLineLabel.text, mockItem0.headline)
        XCTAssertEqual(vc.collectionView(vc.collectionView, numberOfItemsInSection: 0), 3)
    }
    
}
