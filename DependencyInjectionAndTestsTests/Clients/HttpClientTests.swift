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
}
