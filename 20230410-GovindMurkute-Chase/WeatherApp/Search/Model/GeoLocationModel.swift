//
//  GeoLocationModel.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import Foundation

struct GeoLocationModel: Codable {
    let name: String?
    let country: String?
    let state: String?
    let lat: Double?
    let lon: Double?
}
