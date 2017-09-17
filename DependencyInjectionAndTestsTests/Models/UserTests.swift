//
//  UserTests.swift
//  DependencyInjectionAndTests
//
//  Created by Cassius Pacheco on 17/9/17.
//  Copyright © 2017 Cassius Pacheco. All rights reserved.
//

import Foundation
import XCTest
@testable import DependencyInjectionAndTests

class UserTests: XCTestCase {

    func testInitializer() {
     
        let user = User(name: "Cassius")
        
        XCTAssertEqual(user.name, "Cassius")
    }
}
