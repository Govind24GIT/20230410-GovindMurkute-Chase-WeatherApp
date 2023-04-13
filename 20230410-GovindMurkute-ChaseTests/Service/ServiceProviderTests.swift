//
//  ServiceProviderTests.swift
//  20230410-GovindMurkute-ChaseTests
//
//  Created by Govind Murkute on 12/04/23.
//

import XCTest
import Foundation
@testable import WeatherApp

final class ServiceProviderTests: XCTestCase {

    private var serviceProvider: ServiceProvider<WearhterService>!
    
    override func setUp() {
        super.setUp()
        serviceProvider = ServiceProvider()
    }
    
    // MARK: - Geo Search API tests
    func testLoadAPIShouldFail() {
        let expectation = expectation(description: "Geocoder API should fail due to wrong city entered")
        var tempData: Data?

        serviceProvider.load(service: .geoSearch(city: "")) { result in
            expectation.fulfill()
            switch result {
            case .success(let data, let response):
                if  (200...299).contains(response.statusCode) {
                    tempData = data
                }
            case .failure(_, let response):
                XCTAssertEqual(response.statusCode, 400)
            }
        }
        
        waitForExpectations(timeout: 1) { (error) in
          XCTAssertNil(tempData)
        }
    }
    
    func testLoadAPIShouldSuccess() {
        let expectation = expectation(description: "Geocoder API should Success")
        var tempData: Data?

        serviceProvider.load(service: .geoSearch(city: "pune")) { result in
            expectation.fulfill()
            switch result {
            case .success(let data, let response):
                if  (200...299).contains(response.statusCode) {
                    tempData = data
                }
            case .failure(_, _):
                break
            }
        }
        
        waitForExpectations(timeout: 1) { (error) in
          XCTAssertNotNil(tempData)
        }
    }

    // MARK: - Weather Details API tests using mock service provider
    func testWeatherDetailsAPIShouldSuccess() {
        let mockService = MockServiceProvider<WearhterService>(result: .success(mockWeatherDetailsSucccessResponseData(), HTTPURLResponse()))
        let weatherInfoModel = WeatherInfoViewModel(provider: mockService)
        weatherInfoModel.fetchWeather {
            XCTAssertNotNil(weatherInfoModel.weatherInfo)
            XCTAssertEqual(weatherInfoModel.weatherInfo?.name, "Mumbai")
        }
    }
    
    func testWeatherDetailsAPIShouldFail() {
        let mockService = MockServiceProvider<WearhterService>(result: .failure(NetworkError.serverError(statusCode: 401), HTTPURLResponse()))
        let weatherInfoModel = WeatherInfoViewModel(provider: mockService)
        weatherInfoModel.fetchWeather {
            XCTAssertNil(weatherInfoModel.weatherInfo)
        }
    }

    func mockWeatherDetailsSucccessResponseData() -> Data {
        let jsonString = "{\"coord\":{\"lon\":72.8479,\"lat\":19.0144},\"weather\":[{\"id\":711,\"main\":\"Smoke\",\"description\":\"smoke\",\"icon\":\"50d\"}],\"base\":\"stations\",\"main\":{\"temp\":307.14,\"feels_like\":313.31,\"temp_min\":307.14,\"temp_max\":307.14,\"pressure\":1010,\"humidity\":55},\"visibility\":3500,\"wind\":{\"speed\":4.12,\"deg\":270},\"clouds\":{\"all\":40},\"dt\":1681373098,\"sys\":{\"type\":1,\"id\":9052,\"country\":\"IN\",\"sunrise\":1681347191,\"sunset\":1681392297},\"timezone\":19800,\"id\":1275339,\"name\":\"Mumbai\",\"cod\":200}"
        
        return jsonString.data(using: .utf8) ?? Data()
    }
}
