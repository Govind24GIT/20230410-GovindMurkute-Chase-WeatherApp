//
//  Double+StringValue.swift
//  WeatherApp
//
//  Created by Govind Murkute on 13/04/23.
//

import Foundation

extension Double {
    
    func stringValue() -> String {
        String(format: "%f", self)
    }
}
