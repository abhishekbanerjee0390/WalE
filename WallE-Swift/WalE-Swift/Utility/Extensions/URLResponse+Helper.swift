//
//  URLResponse+Helper.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 06/04/22.
//

import Foundation

extension URLResponse {
    var httpStatusCode: Int? {
        return (self as? HTTPURLResponse)?.statusCode
    }
}
