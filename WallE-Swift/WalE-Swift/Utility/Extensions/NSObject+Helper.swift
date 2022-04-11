//
//  NSObject+Helper.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 11/04/22.
//

import Foundation

extension NSObject {
    func runOnMainThread(_ block: @escaping () -> Void) {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                block()
            }
        } else {
            block()
        }
    }
}
