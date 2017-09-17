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
        
        // we perform the method that will use our mock class' result, parse and return an object
        client.login(username: "username", password: "password") { result in
            
            if case .successful(let resultUser) = result {
                
                user = resultUser
            }
        }
        
        // test if the dictionary was well parsed and returned an object User with the expected name
        XCTAssertEqual(user?.name, "Cassius")
    }
}
