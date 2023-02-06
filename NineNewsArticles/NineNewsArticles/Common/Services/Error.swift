//
//  Error.swift
//  NineNewsArticles
//
//  Created by Abdullah Al-Ashi on 3/2/2023.
//

enum NetworkError: Error, Equatable {
    case serializationError(Error)
    case invalidResponse(String)
    case unexpectedError
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case
            (.serializationError, .serializationError),
            (.unexpectedError, .unexpectedError):
            return true
            
        case (.invalidResponse(let hlsAValue), .invalidResponse(let rlsAValue)):
            return hlsAValue == rlsAValue
            
        default:
            return false
        }
    }
}
