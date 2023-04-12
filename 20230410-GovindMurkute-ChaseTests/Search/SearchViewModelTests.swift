//
//  SearchViewModelTests.swift
//  20230410-GovindMurkute-ChaseTests
//
//  Created by Govind Murkute on 12/04/23.
//

import XCTest
import Foundation
@testable import WeatherApp

final class SearchViewModelTests: XCTestCase {

    private var viewModel: SearchViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SearchViewModel()
    }
    
    func testPerformSearch() {
        viewModel.performSearch(text: "Pune")
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertNil(viewModel.geoLocationList)
    }
}
