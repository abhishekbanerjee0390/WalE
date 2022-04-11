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
    
    func daysAgo(_ day: Int, dateFormat format: String = WALEDateConstant.dateFormat) -> Date? {
        return Calendar.current.date(byAdding: .day, value: -day, to: self)
    }
}
