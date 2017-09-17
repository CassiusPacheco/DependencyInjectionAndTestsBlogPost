//
//  HttpClientMock.swift
//  DependencyInjectionAndTests
//
//  Created by Cassius Pacheco on 17/9/17.
//  Copyright © 2017 Cassius Pacheco. All rights reserved.
//

import Foundation
@testable import DependencyInjectionAndTests

class HttpClientMock: HttpClientProtocol {
    
    var mockDataTask: URLSessionDataTask?
    
    var mockResult: Result<JSONDictionary>?
    
    func request(endpoint: String, httpMethod: HttpMethod, bodyData: JSONDictionary?, onCompletion: @escaping (Result<JSONDictionary>) -> Void) -> URLSessionDataTask? {
        
        if let result = mockResult {
            
            onCompletion(result)
        }
        
        return mockDataTask
    }
}
