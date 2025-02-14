//
//  CityViewModelTests.swift
//  MobileChallengeUalaTests
//
//  Created by Nacho Mendez on 14/02/2025.
//

import XCTest
@testable import MobileChallengeUala

final class CityViewModelTests: XCTestCase {
    var viewModel: CityViewModel!
    var mockService: MockCityViewService!
    
    override func setUp() {
        super.setUp()
        mockService = MockCityViewService()
        viewModel = CityViewModel(cityService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchCities() async throws {
        XCTAssertTrue(viewModel.isLoading)
        
        try await viewModel.fetchCities()
        
        XCTAssertEqual(viewModel.cities.count, 2)
    }
    
    func testFilterCities() {
        viewModel.cities = [
            CityModel(country: "Argentina", name: "Buenos Aires", id: 1, coord: Coord(lon: 1.0, lat: 1.0)),
            CityModel(country: "Argentina", name: "Cordoba", id: 2, coord: Coord(lon: 1.0, lat: 1.0))
        ]
        
        viewModel.searchText = "buenos"
        viewModel.filterCities()
        
        let expectation = XCTestExpectation(description: "Wait for filtering")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.filteredCities.count, 1)
            XCTAssertEqual(self.viewModel.filteredCities.first?.name, "Buenos Aires")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLowercaseNameProperty() {
        let city = CityModel(country: "Argentina", name: "Mendoza", id: 3, coord: Coord(lon: 1.0, lat: 1.0))
        XCTAssertEqual(city.lowercaseName, "mendoza")
    }
}
