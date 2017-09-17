//
//  UserSessionTests.swift
//  DependencyInjectionAndTests
//
//  Created by Cassius Pacheco on 17/9/17.
//  Copyright © 2017 Cassius Pacheco. All rights reserved.
//

import Foundation
import XCTest
@testable import DependencyInjectionAndTests

class UserSessionTests: XCTestCase {
    
    func testCurrentUserIsSetOnLogin() {
        
        let authentication = AuthenticationClientMock()
        authentication.mockResult = .successful(User(name: "Cassius"))
        
        let session = UserSession(authenticationClient: authentication, notificationCenter: NotificationCenterMock())
        
        session.login(username: "username", password: "password") { (error) in }
        
        XCTAssertEqual(session.currentUser?.name, "Cassius")
    }
    
    func testNotificationIsTriggeredOnLogin() {
        
        let authentication = AuthenticationClientMock()
        authentication.mockResult = .successful(User(name: "Cassius"))
        
        let notificationCenter = NotificationCenterMock()
        
        let session = UserSession(authenticationClient: authentication, notificationCenter: notificationCenter)
        
        session.login(username: "username", password: "password") { (error) in }
        
        XCTAssertEqual(notificationCenter.namePostReceived, Notification.Name.userLoginStatusUpdatedNotification)
    }
    
    func testNotificationIsTriggeredOnLogout() {
        
        let notificationCenter = NotificationCenterMock()
        
        let session = UserSession(authenticationClient: AuthenticationClientMock(), notificationCenter: notificationCenter)
        
        session.logout()
        
        XCTAssertEqual(notificationCenter.namePostReceived, Notification.Name.userLoginStatusUpdatedNotification)
    }
}
