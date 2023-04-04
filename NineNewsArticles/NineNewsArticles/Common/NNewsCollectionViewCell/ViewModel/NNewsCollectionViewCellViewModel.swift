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
    var imageUrl: String?
    var fallBackImageName: String?
    
    init(headLine: String, abstract: String, signature: String, imageUrl: String?, fallBackImageName: String?) {
        self.headLine = headLine
        self.abstract = abstract
        self.signature = signature
        self.imageUrl = imageUrl
        self.fallBackImageName = fallBackImageName
    }
}
