//
//  MockServiceProvider.swift
//  20230410-GovindMurkute-ChaseTests
//
//  Created by Govind Murkute on 13/04/23.
//

import Foundation
@testable import WeatherApp

class MockServiceProvider<T: Service, M: Codable>: ServiceProviderProtocol {
    var urlSession = URLSession.shared
    var result: Result<M, HTTPURLResponse>
    
    init(result: Result<M, HTTPURLResponse>) {
        self.result = result
    }
    
    func load<M: Codable>(type: M.Type, service: T, completion: @escaping (Result<M, HTTPURLResponse>) -> Void) {
//        completion(result)
    }
    
    func getWeatherImage(url: URL, completion: @escaping (Data?, Error?) -> Void) { }
}
