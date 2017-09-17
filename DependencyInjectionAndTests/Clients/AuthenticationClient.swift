//
//  AuthenticationClient.swift
//  DependencyInjectionAndTests
//
//  Created by Cassius Pacheco on 17/9/17.
//  Copyright © 2017 Cassius Pacheco. All rights reserved.
//

import Foundation

protocol AuthenticationClientProtocol {
    
    func login(username: String, password: String, onCompletion: @escaping (Result<User>) -> Void)
}

final class AuthenticationClient: AuthenticationClientProtocol {
    
    private let httpClient: HttpClientProtocol
    
    convenience init() {
        
        self.init(httpClient: HttpClient())
    }
    
    init(httpClient: HttpClientProtocol) {
        
        self.httpClient = httpClient
    }
    
    func login(username: String, password: String, onCompletion: @escaping (Result<User>) -> Void) {
        
        let data: JSONDictionary = ["username": username, "password": password]
        
        httpClient.request(endpoint: "/oauth", httpMethod: .POST, bodyData: data) { result in
            
            switch result {
                
            case .successful(let dictionary):
                
                if let name = dictionary["name"] as? String {
                    
                    onCompletion(.successful(User(name: name)))
                }
                else {
                    
                    onCompletion(.failed(.parsing))
                }
                
            case .failed(let error):
                
                onCompletion(.failed(error))
            }
        }
    }
}
