//
//  AppCache.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import Foundation
import UIKit

class AppCache {
    
    static let shared = AppCache()
    private init() {}
    
    var imageCache = Cache<String, UIImage>()
}
