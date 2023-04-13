//
//  MockServiceProvider.swift
//  20230410-GovindMurkute-ChaseTests
//
//  Created by Govind Murkute on 13/04/23.
//

import Foundation
@testable import WeatherApp

class MockServiceProvider<T: Service>: ServiceProviderProtocol {
    
    var urlSession = URLSession.shared
    var result: Result
    
    init(result: Result) {
        self.result = result
    }
    
    func load(service: T, completion: @escaping (Result) -> Void) {
        completion(result)
    }
    
    func getWeatherImage(url: URL, completion: @escaping (Data?, Error?) -> Void) { }
}
