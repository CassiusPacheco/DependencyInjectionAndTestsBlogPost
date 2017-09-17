//
//  AuthenticationClientTests.swift
//  DependencyInjectionAndTests
//
//  Created by Cassius Pacheco on 17/9/17.
//  Copyright © 2017 Cassius Pacheco. All rights reserved.
//

import Foundation
import XCTest
@testable import DependencyInjectionAndTests

class AuthenticationClientTests: XCTestCase {
    
    func testReturnsUserForValidResponse() {
        
        // We create an instance of a mock class that conforms to HttpClientProtocol
        let httpClient = HttpClientMock()
        
        // we make this mock class return an expected dictionary
        httpClient.mockResult = .successful(["name": "Cassius"])
        
        // injecting the mock class in our class that's being tested
        let client = AuthenticationClient(httpClient: httpClient)
        
        var user: User?
        var error: HttpError?
        
        // we perform the method that will use our mock class' result, parse and return an object
        client.login(username: "username", password: "password") { result in
            
            switch result {
                
            case .successful(let resultUser):
                
                user = resultUser
                
            case .failed(let resultError):
                
                error = resultError
            }
        }
        
        // test if the dictionary was well parsed and returned an object User with the expected name
        XCTAssertEqual(user?.name, "Cassius")
        XCTAssertNil(error)
    }
    
    func testReturnsParsingErrorIfNameIsNotFoundInDictionary() {
        
        let httpClient = HttpClientMock()
        
        httpClient.mockResult = .successful(["notName": "somethingelse"])
        
        let client = AuthenticationClient(httpClient: httpClient)
        
        var user: User?
        var error: HttpError?
        
        client.login(username: "username", password: "password") { result in
            
            switch result {
               
            case .successful(let resultUser):
                
                user = resultUser
                
            case .failed(let resultError):
                
                error = resultError
            }
        }
        
        XCTAssertNil(user)
        XCTAssertEqual(error, .parsing)
    }
    
    func testPOSTBodyDataBeingSent() {
        
        let httpClient = HttpClientMock()
        
        let client = AuthenticationClient(httpClient: httpClient)

        client.login(username: "cassius", password: "123") { result in }
        
        XCTAssertEqual(httpClient.bodyDataReceived?["username"] as? String, "cassius")
        XCTAssertEqual(httpClient.bodyDataReceived?["password"] as? String, "123")
    }
    
}
