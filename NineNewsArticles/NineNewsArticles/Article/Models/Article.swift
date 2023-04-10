//
//  Article.swift
//  NineNewsArticles
//
//  Created by Abdullah Al-Ashi on 3/2/2023.
//

import Foundation

// MARK: - Article
struct ArticleResponse: Codable {
    let articles: [Article]
    
    enum CodingKeys: String, CodingKey {
        case articles = "assets"
    }
}

// MARK: - Asset
struct Article: Codable {
    let id: Int
    let url: String
    let headline, theAbstract: String
    let byLine: String
    let relatedImages: [AssetRelatedImage]
    let timeStamp: Int
    
    //TODO: add tests
    var smallestImageURL: String? {
        return relatedImages.min{ $0.size < $1.size }?.url
    }
}

// MARK: - AssetRelatedImage
struct AssetRelatedImage: Codable {
    
    let id: Int
    let url: String
    let width, height: Int
    let xLarge2X, large2X: String?
    let timeStamp: Int
    let xLarge, large, thumbnail2X, thumbnail: String?

    enum CodingKeys: String, CodingKey {
        case id, url, width, height
        case xLarge2X = "xLarge@2x"
        case large2X = "large@2x"
        case timeStamp, xLarge, large
        case thumbnail2X = "thumbnail@2x"
        case thumbnail
    }
    
    var size: Int {
        return width * height
    }
}
