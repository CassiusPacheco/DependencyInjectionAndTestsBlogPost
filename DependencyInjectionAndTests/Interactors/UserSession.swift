//
//  UserSession.swift
//  DependencyInjectionAndTests
//
//  Created by Cassius Pacheco on 17/9/17.
//  Copyright © 2017 Cassius Pacheco. All rights reserved.
//

import Foundation

protocol UserSessionProtocol {
    
    var currentUser: User? { get }
    
    var isLoggedIn: Bool { get }
    
    func login(username: String, password: String, onError: @escaping (String) -> Void)
    func logout()
}

final class UserSession: UserSessionProtocol {
    
    private let notificationCenter: NotificationCenterProtocol
    
    private let authenticationClient: AuthenticationClientProtocol
    
    static let shared: UserSession = UserSession()
    
    private (set) var currentUser: User?
    
    var isLoggedIn: Bool {
        
        return currentUser != nil
    }
    
    convenience init() {
        
        self.init(authenticationClient: AuthenticationClient(), notificationCenter: NotificationCenter.default)
    }
    
    init(authenticationClient: AuthenticationClientProtocol, notificationCenter: NotificationCenterProtocol) {
        
        self.authenticationClient = authenticationClient
        self.notificationCenter = notificationCenter
    }
    
    func login(username: String, password: String, onError: @escaping (String) -> Void) {
        
        authenticationClient.login(username: username, password: password) { (result) in
            
            if case .successful(let user) = result {
                
                self.currentUser = user
                
                // Broadcast to the whole app the login status update
                self.notificationCenter.post(name: .userLoginStatusUpdatedNotification, object: nil)
            }
            else {
                
                // TODO: read the error and return a proper error message
                onError("There was an error processing your login. Please try again")
            }
        }
    }
    
    func logout() {
        
        // perform any logout operation
        
        currentUser = nil
        
        // Broadcast to the whole app the login status update
        notificationCenter.post(name: .userLoginStatusUpdatedNotification, object: nil)
    }
}
