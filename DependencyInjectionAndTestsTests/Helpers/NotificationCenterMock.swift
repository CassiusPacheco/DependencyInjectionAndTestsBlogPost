//
//  NotificationCenterMock.swift
//  DependencyInjectionAndTests
//
//  Created by Cassius Pacheco on 17/9/17.
//  Copyright © 2017 Cassius Pacheco. All rights reserved.
//

import Foundation
@testable import DependencyInjectionAndTests

class NotificationCenterMock: NotificationCenterProtocol {
    
    private(set) var namePostReceived: NSNotification.Name?
    private(set) var objectPostReceived: Any?
    
    private(set) var nameObserverReceived: NSNotification.Name?
    private(set) var selectorObserverReceived: Selector?
    private(set) var objectObserverReceived: Any?
    
    func post(name aName: NSNotification.Name, object anObject: Any?) {
        
        namePostReceived = aName
        objectPostReceived = anObject
    }
    
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?) {
        
        nameObserverReceived = aName
        selectorObserverReceived = aSelector
        objectObserverReceived = anObject
    }
}
