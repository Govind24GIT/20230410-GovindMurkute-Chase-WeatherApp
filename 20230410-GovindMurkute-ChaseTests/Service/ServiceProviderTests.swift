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

}
