//
//  Article.swift
//  NineNewsArticles
//
//  Created by Abdullah Al-Ashi on 3/2/2023.
//

import Foundation

// MARK: - Article
struct ArticleResponse: Codable {
    let id: Int
    let categories, authors: [JSONAny]
    let url: String
    let lastModified, onTime: Int
    let sponsored: Bool
    let displayName: String
    let articles: [Article]
    let relatedAssets, relatedImages: [JSONAny]
    let assetType: String
    let timeStamp: Int
    
    enum CodingKeys: String, CodingKey {
        case id, categories, authors, url, lastModified, onTime, sponsored, displayName, relatedAssets, relatedImages, assetType, timeStamp
        case articles = "assets"
    }
}

// MARK: - Asset
struct Article: Codable {
    let id: Int
    let categories: [Category]
    let authors: [Author]
    let url: String
    let lastModified: Int
    let sponsored: Bool
    let headline, indexHeadline, tabletHeadline, theAbstract: String
    let byLine: String
    let acceptComments: Bool
    let numberOfComments: Int
    let relatedAssets: [RelatedAsset]
    let relatedImages: [AssetRelatedImage]
    let companies: [Company]
    let legalStatus: LegalStatus
    let sources: [Source]
    let assetType: AssetAssetType
    let overrides: Overrides
    let timeStamp: Int
    let signPost: String?
    let onTime: Int?
}

enum AssetAssetType: String, Codable {
    case article = "ARTICLE"
}

// MARK: - Author
struct Author: Codable {
    let name, title, email: String
    let relatedAssets: [JSONAny]
    let relatedImages: [AuthorRelatedImage]
}

// MARK: - AuthorRelatedImage
struct AuthorRelatedImage: Codable {
    let id: Int
    let categories, brands, authors: [JSONAny]
    let url: String
    let lastModified: Int
    let sponsored: Bool
    let description: Description
    let photographer: String
    let type: PurpleType
    let width, height: Int
    let assetType: RelatedImageAssetType
    let timeStamp: Int
}

enum RelatedImageAssetType: String, Codable {
    case image = "IMAGE"
}

enum Description: String, Codable {
    case description = " "
    case empty = ""
    case ronaldMizenAFRWoodcut = "Ronald Mizen AFR Woodcut"
}

enum PurpleType: String, Codable {
    case afrWoodcutAuthorImage = "afrWoodcutAuthorImage"
}

// MARK: - Category
struct Category: Codable {
    let name, sectionPath: String
    let orderNum: Int
}

// MARK: - Company
struct Company: Codable {
    let id: Int
    let companyCode, companyName, abbreviatedName, exchange: String
    let companyNumber: String
}

enum LegalStatus: String, Codable {
    case approved = "Approved"
    case none = "None"
}

// MARK: - Overrides
struct Overrides: Codable {
    let overrideHeadline, overrideAbstract: String
}

// MARK: - RelatedAsset
struct RelatedAsset: Codable {
    let id: Int
    let categories: [Category]
    let authors: [Author]
    let url: String
    let lastModified: Int
    let sponsored: Bool
    let assetType: AssetAssetType
    let headline: String
    let timeStamp: Int
    let onTime: Int?
}

// MARK: - AssetRelatedImage
struct AssetRelatedImage: Codable {
    let id: Int
    let categories, brands, authors: [JSONAny]
    let url: String
    let lastModified: Int
    let sponsored: Bool
    let description, photographer: String
    let type: FluffyType
    let width, height: Int
    let assetType: RelatedImageAssetType
    let xLarge2X, large2X: String?
    let timeStamp: Int
    let xLarge, large, thumbnail2X, thumbnail: String?

    enum CodingKeys: String, CodingKey {
        case id, categories, brands, authors, url, lastModified, sponsored, description, photographer, type, width, height, assetType
        case xLarge2X = "xLarge@2x"
        case large2X = "large@2x"
        case timeStamp, xLarge, large
        case thumbnail2X = "thumbnail@2x"
        case thumbnail
    }
}

enum FluffyType: String, Codable {
    case afrArticleInline = "afrArticleInline"
    case afrArticleLead = "afrArticleLead"
    case afrIndexLead = "afrIndexLead"
    case articleLeadWide = "articleLeadWide"
    case landscape = "landscape"
    case thumbnail = "thumbnail"
    case wideLandscape = "wideLandscape"
}

// MARK: - Source
struct Source: Codable {
    let tagID: TagID

    enum CodingKeys: String, CodingKey {
        case tagID = "tagId"
    }
}

enum TagID: String, Codable {
    case afr = "AFR"
    case washingtonPost = "Washington Post"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}