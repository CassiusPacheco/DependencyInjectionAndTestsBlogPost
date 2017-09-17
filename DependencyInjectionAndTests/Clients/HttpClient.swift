//
//  HttpClient.swift
//  DependencyInjectionAndTests
//
//  Created by Cassius Pacheco on 17/9/17.
//  Copyright © 2017 Cassius Pacheco. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

enum HttpMethod: String {
    
    case GET = "GET"
    case DELETE = "DELETE"
    case POST = "POST"
    case PUT = "PUT"
}

enum HttpError {
    
    case json
    case parsing
    case unknown
}

enum Result<T> {
    
    case failed(HttpError)
    case successful(T)
}

protocol HttpClientProtocol {
    
    func request(endpoint: String, httpMethod: HttpMethod, bodyData: JSONDictionary?, onCompletion: @escaping (Result<JSONDictionary>) -> Void)
}

final class HttpClient: HttpClientProtocol {
    
    private let baseUrl: String
    
    private let urlSession: URLSessionProtocol
    
    convenience init() {
        
        self.init(baseUrl: "mybaseurl.com", urlSession: URLSession.shared)
    }
    
    init(baseUrl: String, urlSession: URLSessionProtocol) {
        
        self.baseUrl = baseUrl
        self.urlSession = urlSession
    }
    
    func request(endpoint: String, httpMethod: HttpMethod, bodyData: JSONDictionary?, onCompletion: @escaping (Result<JSONDictionary>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let bodyData = bodyData, httpMethod == .POST || httpMethod == .PUT {
            
            do {
                
                let json = try JSONSerialization.data(withJSONObject: bodyData, options: [])
                
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                
                request.httpBody = json
            }
            catch {
                
                DispatchQueue.main.async {
                    
                    onCompletion(.failed(.json))
                }
                
                return
            }
        }
        
        let task = urlSession.dataTask(with: request) { (data, urlResponse, error) -> Void in
            
            var errorResponse = HttpError.unknown
            
            do {
                
                if let data = data, data.count > 0,
                    let response = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? JSONDictionary {
                    
                    DispatchQueue.main.async {
                        
                        onCompletion(.successful(response))
                    }
                }
            }
            catch {
                
                // handle error properly
                errorResponse = .json
            }
            
            DispatchQueue.main.async {
                
                // ideally we'd map the error properly
                onCompletion(.failed(errorResponse))
            }
        }
        
        task.resume()
    }
}
