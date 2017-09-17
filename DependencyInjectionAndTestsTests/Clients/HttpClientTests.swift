//
//  HttpClientTests.swift
//  DependencyInjectionAndTests
//
//  Created by Cassius Pacheco on 17/9/17.
//  Copyright © 2017 Cassius Pacheco. All rights reserved.
//

import Foundation
import XCTest
@testable import DependencyInjectionAndTests

class HttpClientTests: XCTestCase {
    
    func testReturnsJsonErrorForInvalidJsonFromServer() {
        
        // This test ensures that an invalid JSON received from the server triggers a .json error
        
        let expectation = self.expectation(description: "testReturnsSuccessfulDictionary")
        
        let urlSession = URLSessionMock()
        urlSession.mockData = "invalid json".data(using: .utf8)
        
        XCTAssertNotNil(urlSession.mockData)
        
        let client = HttpClient(baseUrl: "baseurl.com", urlSession: urlSession)
        
        var dictionary: JSONDictionary?
        var error: HttpError?
        
        client.request(endpoint: "/endpoint", httpMethod: .GET, bodyData: nil) { result in
            
            if case .successful(let resultDictionary) = result {
                
                dictionary = resultDictionary
            }
            
            if case .failed(let resultError) = result {
                
                error = resultError
            }
            
            expectation.fulfill()
        }
        
        XCTWaiter().wait(for: [expectation], timeout: 1.0)
        
        XCTAssertNil(dictionary)
        XCTAssertEqual(error, .json)
    }
    
    func testReturnsDictionaryForValidJsonFromServer() {
        
        // This test ensures that a valid JSON received from the server is properly parse into a dictionary
        
        let expectation = self.expectation(description: "testReturnsDictionaryForValidJsonFromServer")
        
        let urlSession = URLSessionMock()
        urlSession.mockData = try? JSONSerialization.data(withJSONObject: ["key": "value"], options: [])
        
        XCTAssertNotNil(urlSession.mockData)
        
        let client = HttpClient(baseUrl: "baseurl.com", urlSession: urlSession)
        
        var dictionary: JSONDictionary?
        var error: HttpError?
        
        client.request(endpoint: "/endpoint", httpMethod: .GET, bodyData: nil) { result in
            
            if case .successful(let resultDictionary) = result {
                
                dictionary = resultDictionary
            }
            
            if case .failed(let resultError) = result {
                
                error = resultError
            }
            
            expectation.fulfill()
        }
        
        XCTWaiter().wait(for: [expectation], timeout: 1.0)
        
        XCTAssertNil(error)
        XCTAssertEqual(dictionary?["key"] as? String, "value")
    }
    
    func testReturnsUnknownForEmptyResponses() {
        
        let expectation = self.expectation(description: "testReturnsUnknownForEmptyResponses")
        
        let urlSession = URLSessionMock()
        
        let client = HttpClient(baseUrl: "baseurl.com", urlSession: urlSession)
        
        var dictionary: JSONDictionary?
        var error: HttpError?
        
        client.request(endpoint: "/endpoint", httpMethod: .GET, bodyData: nil) { result in
            
            if case .successful(let resultDictionary) = result {
                
                dictionary = resultDictionary
            }
            
            if case .failed(let resultError) = result {
                
                error = resultError
            }
            
            expectation.fulfill()
        }
        
        XCTWaiter().wait(for: [expectation], timeout: 1.0)
        
        XCTAssertNil(dictionary)
        XCTAssertEqual(error, .unknown)
    }
    
    func testCallsResume() {
        
        // This test ensures `resume()` is called for the task created
        
        let task = URLSessionDataTaskMock()
        
        let urlSession = URLSessionMock()
        urlSession.mockURLSessionDataTask = task
        
        let client = HttpClient(baseUrl: "baseurl.com", urlSession: urlSession)
        
        client.request(endpoint: "/endpoint", httpMethod: .GET, bodyData: nil) { result in }
        
        XCTAssertTrue(task.hasResumeBeenCalled)
    }
    
    func testInvalidUrl() {
        
        let urlSession = URLSessionMock()
        
        let client = HttpClient(baseUrl: "%$#%#$", urlSession: urlSession)
        
        client.request(endpoint: "invalidendpoint", httpMethod: .GET, bodyData: nil) { result in }
        
        XCTAssertNil(urlSession.requestReceived)
    }
}
