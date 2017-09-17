//
//  URLSessionProtocol.swift
//  DependencyInjectionAndTests
//
//  Created by Cassius Pacheco on 17/9/17.
//  Copyright © 2017 Cassius Pacheco. All rights reserved.
//

import Foundation

protocol URLSessionProtocol: class {
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }
