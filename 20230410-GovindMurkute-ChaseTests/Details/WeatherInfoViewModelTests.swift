//
//  WeatherInfoViewModelTests.swift
//  20230410-GovindMurkute-ChaseTests
//
//  Created by Govind Murkute on 13/04/23.
//

import XCTest
import Foundation
@testable import WeatherApp

final class WeatherInfoViewModelTests: XCTestCase {
    
    private var viewModel: WeatherInfoViewModel!
    private var mockService: MockServiceProvider<WearhterService>!
    
    override func setUp() {
        super.setUp()
        mockService = MockServiceProvider<WearhterService>(result: .success(mockWeatherDetailsSucccessResponseData(), HTTPURLResponse()))
        viewModel = WeatherInfoViewModel(provider: mockService)
    }
    
    func mockWeatherDetailsSucccessResponseData() -> Data {
        let jsonString = "{\"coord\":{\"lon\":72.8479,\"lat\":19.0144},\"weather\":[{\"id\":711,\"main\":\"Smoke\",\"description\":\"smoke\",\"icon\":\"50d\"}],\"base\":\"stations\",\"main\":{\"temp\":307.14,\"feels_like\":313.31,\"temp_min\":307.14,\"temp_max\":307.14,\"pressure\":1010,\"humidity\":55},\"visibility\":3500,\"wind\":{\"speed\":4.12,\"deg\":270},\"clouds\":{\"all\":40},\"dt\":1681373098,\"sys\":{\"type\":1,\"id\":9052,\"country\":\"IN\",\"sunrise\":1681347191,\"sunset\":1681392297},\"timezone\":19800,\"id\":1275339,\"name\":\"Mumbai\",\"cod\":200}"
        
        return jsonString.data(using: .utf8) ?? Data()
    }

    func testFetchWeatherInfoSuccess() {
        viewModel.fetchWeather {
            XCTAssertNotNil(self.viewModel.weatherInfo)
            XCTAssertEqual(self.viewModel.weatherInfo?.name, "Mumbai")
        }
    }
}
