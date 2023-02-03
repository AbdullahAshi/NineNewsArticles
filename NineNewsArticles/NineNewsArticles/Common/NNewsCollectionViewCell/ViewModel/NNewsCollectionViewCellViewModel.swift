//
//  NNewsCollectionViewCellViewModel.swift
//  CSChallenge
//
//  Created by Abdullah Al-Ashi on 18/7/21.
//  Copyright © 2021 Abdullah Al-Ashi. All rights reserved.
//

import Foundation

class NNewsCollectionViewCellViewModel: NNewsCollectionViewCellViewModelProtocol {
    var headLine: String
    var abstract: String
    var signature: String
    var imageUrl: String
    
    init(title: String, price: String, signature: String, imageUrl: String) {
        self.headLine = title
        self.abstract = price
        self.signature = signature
        self.imageUrl = imageUrl
    }
}
