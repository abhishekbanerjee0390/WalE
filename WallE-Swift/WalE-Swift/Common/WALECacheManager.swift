//
//  WALECacheManager.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 08/04/22.
//

import Foundation


final class WALECacheManager<Element: AnyObject> {
    
    private let cache: NSCache<AnyObject,AnyObject>
    
    init() {
        self.cache = NSCache()
    }
    
    func setCachingObject(forKey key: AnyObject, object: Element) {
        cache.setObject(object, forKey: key)
    }
    
    func cachedObject(forKey key: AnyObject) -> Element? {
        return cache.object(forKey: key) as? Element
    }
}
