//
//  AuthenticationClientMock.swift
//  DependencyInjectionAndTests
//
//  Created by Cassius Pacheco on 17/9/17.
//  Copyright © 2017 Cassius Pacheco. All rights reserved.
//

import Foundation
@testable import DependencyInjectionAndTests

class AuthenticationClientMock: AuthenticationClientProtocol {
    
    private(set) var usernameReceived: String?
    private(set) var passwordReceived: String?
    
    var mockResult: Result<User>?
    
    func login(username: String, password: String, onCompletion: @escaping (Result<User>) -> Void) {
        
        usernameReceived = username
        passwordReceived = password
        
        if let result = mockResult {
            
            onCompletion(result)
        }
    }
}
