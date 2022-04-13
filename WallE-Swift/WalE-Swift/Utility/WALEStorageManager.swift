//
//  WALEStorageManager.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 10/04/22.
//

import Foundation

protocol WallEStorageManagerProtocol {
    func setObject<Element: Encodable>(value: Element, forKey key: String) throws
    func getObject<Element: Decodable>(forKey key: String) throws -> Element?
}


final class WallEStorageManager: WallEStorageManagerProtocol {
    
    static let shared: WallEStorageManager = WallEStorageManager()
    
    private init() {}
    
    private let userDefault: UserDefaults = UserDefaults.standard
    
    func setObject<Element: Encodable>(value: Element, forKey key: String) throws {
        let dataValue: Data = try JSONEncoder().encode(value)
        userDefault.set(dataValue, forKey: key)
    }
 
    func getObject<Element: Decodable>(forKey key: String) throws -> Element? {
        guard let data = userDefault.data(forKey: key) else {
            return nil
        }
        let dataValue = try JSONDecoder().decode(Element.self, from: data)
        return dataValue
    }
}
