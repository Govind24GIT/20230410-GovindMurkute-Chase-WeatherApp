//
//  WeatherInfo.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import Foundation

struct WeatherInfo: Codable {

    let id: Int?
    let main: Main?
    let name: String?
    let coord: Coord?
    let weather: [Weather]?
    let wind: Wind?
}

struct Main: Codable {
    
    let feelsLike: Float?
    let humidity: Int?
    let pressure: Int?
    let temp: Float?
    let temp_max: Float?
    let temp_min: Float?
}

struct Weather: Codable {
    
    let description: String?
    let icon: String?
    let id: Int?
    let main: String?
}

struct Wind: Codable {
    
    let deg: Float?
    let speed: Float?
}

struct Coord: Codable  {
    
    let lon: Double?
    let lat: Double?
}
