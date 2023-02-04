//
//  ArticleResponseFactory.swift
//  NineNewsArticlesTests
//
//  Created by Abdullah Al-Ashi on 3/2/2023.
//

import Foundation

@testable import NineNewsArticles

class ArticleResponseFactory {
    enum ArticleFactoryResponseError: Error {
        case unableToLoadResponse
        case unableToLoadData
    }
    
    static func articleResponse() throws -> ArticleResponse {
        let testBundle = Bundle(for: ArticleResponseFactory.self)
        guard let path = testBundle.path(forResource: "nineNews-articles-response-success", ofType: "json") else {
            assertionFailure()
            throw ArticleFactoryResponseError.unableToLoadResponse
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let response = try JSONDecoder().decode(ArticleResponse.self, from: data)
            return response
        } catch {
            throw ArticleFactoryResponseError.unableToLoadResponse
        }
    }
    
    static func articleData() throws -> Data {
        let testBundle = Bundle(for: ArticleResponseFactory.self)
        guard let path = testBundle.path(forResource: "nineNews-articles-response-success", ofType: "json") else {
            assertionFailure()
            throw ArticleFactoryResponseError.unableToLoadResponse
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let json = try JSONDecoder().decode(ArticleResponse.self, from: data)
            print(json)
            return data
        } catch {
            print(error)
            throw ArticleFactoryResponseError.unableToLoadData
        }
    }
}

extension Article {
    static func mock(id: Int = 0,
                     url: String = "https://www.9news.com/article/test",
                     headline: String = "headLine test",
                     theAbstract: String = "the abstract test",
                     byLine: String = "the author test",
                     relatedImages: [AssetRelatedImage] = [.mock()],
                     timeStamp: Int = 1031731070) -> Self {
        return .init(id: id,
                     url: url,
                     headline: headline,
                     theAbstract: theAbstract,
                     byLine: byLine,
                     relatedImages: relatedImages,
                     timeStamp: timeStamp)
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

