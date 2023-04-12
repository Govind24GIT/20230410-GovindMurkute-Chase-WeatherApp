//
//  KeyWrapper.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import Foundation

class KeyWrapper<KeyType: Hashable>: NSObject {
    let key: KeyType
    init(_ key: KeyType) {
        self.key = key
    }

    override var hash: Int {
        return key.hashValue
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? KeyWrapper<KeyType> else {
            return false
        }
        return key == other.key
    }
}
