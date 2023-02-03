//
//  NetworkService.swift
//  NineNewsArticles
//
//  Created by Abdullah Al-Ashi on 3/2/2023.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    private let urlSession: URLSessionProtocol
    
    static let shared: NetworkServiceProtocol = NetworkService()
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func get<Model: Codable>(url: URL, completion: @escaping NetworkCompletionHandler<Model>)  {
        request(url: url, method: .get, completion: completion)
    }
    
    private func request<Model: Codable>(url: URL,
                                         method: HttpMethod,
                                         completion: @escaping NetworkCompletionHandler<Model>){
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completion(nil, NetworkError.invalidResponse("nil status code"))
                return
            }
            
            guard  200..<299 ~= statusCode else {
                completion(nil, NetworkError.invalidResponse("unsuccessful status code"))
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.invalidResponse("data is nil"))
                return
            }
            
            do {
                let object = try JSONDecoder().decode(Model.self, from: data)
                completion(object, nil)
            } catch {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    print(json ?? ["": ""])
                } catch {
                    print(error)
                }
                completion(nil, NetworkError.serializationError(error))
            }
        }
        task.resume()
    }
    
}
