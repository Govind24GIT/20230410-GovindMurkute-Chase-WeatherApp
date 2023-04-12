//
//  WearhterService.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import Foundation

enum WearhterService {
    case geoSearch(city: String)
    case getWeather(lat: String, long: String)
    /// We can add additional API paths here if any
}

extension WearhterService: Service {
    
    static let apiKey = "b68cdaa6e616015ab5811411b49107f6"  /// App id from openweather account
    static let unit = "metric"
    
    var baseURL: String {
        return "https://api.openweathermap.org"
    }
    
    var path: String {
        switch self {
            
        case .geoSearch(_):
            return "/geo/1.0/direct"
            
        case .getWeather(_, _):
            return "/data/2.5/weather"
        }
    }
    
    var parameters: [String: Any]? {
        // default params
        var params: [String: Any] = ["appid": WearhterService.apiKey]
        
        switch self {
            
        case .geoSearch(city: let city):
            params["q"] = city.replacingOccurrences(of: " ", with: "")
            
        case .getWeather(lat: let lat, long: let long):
            params["lat"] = lat
            params["lon"] = long
            params["units"] = WearhterService.unit
        }
        return params
    }
    
    var method: ServiceMethod {
        return .get
    }
}
