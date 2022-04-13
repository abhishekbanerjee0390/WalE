//
//  URLSession+WALEURLSessionProtocol.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 06/04/22.
//

import Foundation

extension URLSession: WALEURLSessionProtocol {
    func task(withRequest request: URLRequest, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> WALEURLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler)
    }
}


extension URLSessionDataTask: WALEURLSessionDataTaskProtocol {
    
}
