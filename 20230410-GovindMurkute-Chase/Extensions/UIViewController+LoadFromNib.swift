//
//  UIViewController+LoadFromNib.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import Foundation
import UIKit

extension UIViewController {
    static func initFromNib() -> Self {
        return Self.init(nibName: String(describing: self), bundle: .main)
    }
}
