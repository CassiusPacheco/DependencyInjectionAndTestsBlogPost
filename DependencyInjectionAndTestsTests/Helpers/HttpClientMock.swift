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
    
    private(set) var endpointReceived: String?
    private(set) var httpMethodReceived: HttpMethod?
    private(set) var bodyDataReceived: JSONDictionary?
    
    var mockResult: Result<JSONDictionary>?
    
    func request(endpoint: String, httpMethod: HttpMethod, bodyData: JSONDictionary?, onCompletion: @escaping (Result<JSONDictionary>) -> Void) {
        
        endpointReceived = endpoint
        httpMethodReceived = httpMethod
        bodyDataReceived = bodyData
        
        if let result = mockResult {
            
            onCompletion(result)
        }
    }
}
