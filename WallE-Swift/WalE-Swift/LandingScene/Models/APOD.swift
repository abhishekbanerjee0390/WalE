//
//  APOD.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 06/04/22.
//

import Foundation


struct APOD:  Codable {
    
    let dateString: String
    let explanation: String
    let title: String
    let urlString: String
    //imageData is updated from local scope, not from API response
    var imageData: Data?

    enum CodingKeys: String, CodingKey {
        case dateString = "date"
        case explanation, title
        case urlString = "url"
        case imageData = "imageData"
    }
}

