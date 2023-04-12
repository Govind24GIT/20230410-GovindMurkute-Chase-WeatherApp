//
//  Cache.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import Foundation

open class Cache<KeyType: Hashable, ObjectType> {
    
    private let cache: NSCache<KeyWrapper<KeyType>, ObjectWrapper> = NSCache()
    
    public init(lowMemoryAware: Bool = true) {
        guard lowMemoryAware else { return }
    }
    
    @objc private func onLowMemory() {
        removeAllObjects()
    }
    
    open var name: String {
        get { return cache.name }
        set { cache.name = newValue }
    }
    
    weak open var delegate: NSCacheDelegate? {
        get { return cache.delegate }
        set { cache.delegate = newValue }
    }
    
    open func object(forKey key: KeyType) -> ObjectType? {
        return cache.object(forKey: KeyWrapper(key))?.value as? ObjectType
    }
    
    open func setObject(_ obj: ObjectType, forKey key: KeyType) { // 0 cost
        return cache.setObject(ObjectWrapper(obj), forKey: KeyWrapper(key))
    }
    
    open func setObject(_ obj: ObjectType, forKey key: KeyType, cost: Int) {
        return cache.setObject(ObjectWrapper(obj), forKey: KeyWrapper(key), cost: cost)
    }
    
    open func removeObject(forKey key: KeyType) {
        return cache.removeObject(forKey: KeyWrapper(key))
    }
    
    open func removeAllObjects() {
        return cache.removeAllObjects()
    }
    
    open var totalCostLimit: Int {
        get { return cache.totalCostLimit }
        set { cache.totalCostLimit = newValue }
    }
    
    open var countLimit: Int {
        get { return cache.countLimit }
        set { cache.countLimit = newValue }
    }
    
    open var evictsObjectsWithDiscardedContent: Bool {
        get { return cache.evictsObjectsWithDiscardedContent }
        set { cache.evictsObjectsWithDiscardedContent = newValue }
    }
}
