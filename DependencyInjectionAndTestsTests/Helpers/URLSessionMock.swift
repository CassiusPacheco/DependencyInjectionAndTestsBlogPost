//
//  URLSessionMock.swift
//  DependencyInjectionAndTests
//
//  Created by Cassius Pacheco on 17/9/17.
//  Copyright © 2017 Cassius Pacheco. All rights reserved.
//

import Foundation
@testable import DependencyInjectionAndTests

class URLSessionMock: URLSessionProtocol {
    
    // value received in the method call
    private (set) var requestReceived: URLRequest?
    
    // mock values to be used as response
    var mockData: Data?
    var mockURLResponse: URLResponse?
    var mockError: Error?
    var mockURLSessionDataTask: URLSessionDataTaskProtocol?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        
        requestReceived = request
        
        completionHandler(mockData, mockURLResponse, mockError)
        
        return mockURLSessionDataTask ?? URLSessionDataTaskMock()
    }
}

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    
    private(set) var hasResumeBeenCalled = false
    
    func resume() {
        
        hasResumeBeenCalled = true
    }
}
