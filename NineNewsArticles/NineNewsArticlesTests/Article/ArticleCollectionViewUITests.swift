//
//  ArticleCollectionViewUITests.swift
//  NineNewsArticlesTests
//
//  Created by Abdullah Al-Ashi on 6/2/2023.
//

import XCTest
import SnapshotTesting
import SDWebImage

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
        
        articleSerivce.articles = [.mock(id: 0), .mock(id: 1), .mock(id: 0)]
        //articleViewModel.loadData()
        vc.setup(viewModel: articleViewModel)
//        vc.loadViewIfNeeded()
        let _ = vc.view
        
        //articleViewModel.state == .loaded
        
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.tintColor = .gray
//        vc.beginAppearanceTransition(true, animated: false)
//            vc.endAppearanceTransition()
        UIGraphicsBeginImageContextWithOptions(vc.view.frame.size, false, 0)
            let context = UIGraphicsGetCurrentContext
//        vc.view.layer.render(in: context()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()

        assertSnapshot(matching: vc, as: .wait(for: 3.0, on: .image))
        assertSnapshot(matching: vc, as: .image)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3 , execute: {
////            vc.viewDidLoad()
//            assertSnapshot(matching: vc, as: .image)
//        })
        
    }
    
}
