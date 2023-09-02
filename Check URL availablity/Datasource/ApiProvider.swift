//
//  ApiProvider.swift
//  Check URL availablity
//
//  Created by Reza Sharifi on 9/1/23.
//

import Foundation

protocol ApiProvider {
    func get(from url: String, completion: @escaping (Result<Bool,RequestError>) -> ())
}

enum RequestError: Error {
    case unknownerror
    case invalidUrl
    case connectionError
    case authorizationError
    case notFound
    case invalidResponse
    case serverError
    case serverunavailable
}

class ApiManager: ApiProvider {
    
    enum method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    func get(from url: String, completion: @escaping (Result<Bool, RequestError>) -> ()) {
        let reguestStartTime = Date()
        var url = url
        
        guard url.isValidURL else {
            completion(.failure(.invalidUrl))
            return
        }
        
        if !url.hasPrefix("https://") && !url.hasPrefix("http://") {
            url = "https://" + url
        }
        
        var urlRequest = URLRequest(url: URL(string: url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
        
        urlRequest.httpMethod = method.get.rawValue
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                print(error)
                completion(.failure(.connectionError))
            } else if let responseCode = response as? HTTPURLResponse {
                print(responseCode.statusCode)
                print(responseCode)
                switch responseCode.statusCode {
                case 200:
                    completion(.success(true))
                case 400...499:
                    completion(.failure(.authorizationError))
                case 500...599:
                    completion(.failure(.serverError))
                default:
                    completion(.failure(.unknownerror))
                    break
                }
            }
        }.resume()
    }
}
