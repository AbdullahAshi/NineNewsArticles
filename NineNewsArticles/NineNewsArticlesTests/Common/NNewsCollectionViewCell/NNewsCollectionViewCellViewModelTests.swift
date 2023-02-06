//
//  NNewsCollectionViewCellViewModelTests.swift
//  NineNewsArticlesTests
//
//  Created by Abdullah Al-Ashi on 6/2/2023.
//

import XCTest

@testable import NineNewsArticles

class NNewsCollectionViewCellViewModelTests: XCTestCase {

    func testInitialisation() throws {
        let cellViewModel = NNewsCollectionViewCellViewModel(headLine: "title test", abstract: "abstract test", signature: "signature test", imageUrl: "image url")
        
        XCTAssertEqual(cellViewModel.headLine, "title test")
        XCTAssertEqual(cellViewModel.abstract, "abstract test")
        XCTAssertEqual(cellViewModel.signature, "signature test")
        XCTAssertEqual(cellViewModel.imageUrl, "image url")
    }

}
