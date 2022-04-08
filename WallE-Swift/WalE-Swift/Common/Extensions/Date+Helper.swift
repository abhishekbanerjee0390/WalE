//
//  Date+Helper.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 06/04/22.
//

import Foundation

extension Date {
    func stringValue(withDateFormat format: String = WALEDateConstant.dateFormat) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
