//
//  NetworkServiceProtocol.swift
//  NineNewsArticles
//
//  Created by Abdullah Al-Ashi on 3/2/2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func get<Model: Codable>(url: URL, completion: @escaping NetworkCompletionHandler<Model>)
}
