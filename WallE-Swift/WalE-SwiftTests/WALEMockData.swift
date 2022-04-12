//
//  WALEMockData.swift
//  WalE-SwiftTests
//
//  Created by Abhishek Banerjee on 12/04/22.
//

import XCTest
@testable import WalE_Swift

final class WALEMockData {
    let apod: APOD = {
        
        let dictData: [String: String] = [
               "date": "2022-04-05",
               "explanation": "Astronomy Explanation",
               "title": "Astronomy",
               "url": "https://via.placeholder.com/"
        ]

        let jsonData = try! JSONEncoder().encode(dictData)
        let obj: APOD = try! JSONDecoder().decode(APOD.self, from: jsonData)
        return obj
    }()
    
    let imageData: Data = {
        return (UIImage(named: "placeholder")?.jpegData(compressionQuality: 0.1))!
    }()
}
