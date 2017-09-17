//
//  NotificationCenterProtocol.swift
//  DependencyInjectionAndTests
//
//  Created by Cassius Pacheco on 17/9/17.
//  Copyright © 2017 Cassius Pacheco. All rights reserved.
//

import Foundation

protocol NotificationCenterProtocol {
    
    func post(name aName: NSNotification.Name, object anObject: Any?)
    
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?)
}

extension NotificationCenter: NotificationCenterProtocol {}

extension Notification.Name {
    
    static let userLoginStatusUpdatedNotification = Notification.Name(rawValue: "userLoginStatusUpdatedNotification")
}
