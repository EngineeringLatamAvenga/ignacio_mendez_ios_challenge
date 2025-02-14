//
//  MobileChallengeUalaTests.swift
//  MobileChallengeUalaTests
//
//  Created by Nacho Mendez on 06/02/2025.
//

import XCTest
@testable import MobileChallengeUala

class CityViewServiceTests: XCTestCase {
    
    class URLSessionMock: URLSessionProtocol {
        var dataToReturn: Data?
        var responseToReturn: URLResponse?
        var errorToReturn: Error?
        
        func data(from url: URL) async throws -> (Data, URLResponse) {
            if let error = errorToReturn {
                throw error
            }
            guard let data = dataToReturn, let response = responseToReturn else {
                throw MyErrors.invalidData
            }
            return (data, response)
        }
    }
    
    var sessionMock: URLSessionMock!
    var cityService: CityViewService!
    
    override func setUp() {
        super.setUp()
        sessionMock = URLSessionMock()
        cityService = CityViewService(session: sessionMock)
    }
    
    override func tearDown() {
        sessionMock = nil
        cityService = nil
        super.tearDown()
    }
    
    func testGetCities_Success() async throws {
        let jsonData = """
        [
            { "_id": 1, "name": "Buenos Aires", "country": "AR", "coord": { "lon": -58.38, "lat": -34.61 } },
            { "_id": 2, "name": "Cordoba", "country": "AR", "coord": { "lon": -64.18, "lat": -31.42 } }
        ]
        """.data(using: .utf8)!
        
        let response = HTTPURLResponse(
            url: URL(string: "https://mockurl.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        sessionMock.dataToReturn = jsonData
        sessionMock.responseToReturn = response
        
        let cities = try await cityService.getCities()
        XCTAssertEqual(cities.count, 2)
        XCTAssertEqual(cities.first, CityModel(country: "AR", name: "Buenos Aires", id: 1, coord: Coord(lon: -58.38, lat: -34.61)))
    }
    
    func testGetCities_InvalidURL() async {
        class CityViewServiceWithInvalidURL: CityViewService {
            override func getCities() async throws -> [CityModel] {
                throw MyErrors.invalidURL
            }
        }
        
        let invalidService = CityViewServiceWithInvalidURL()
        
        do {
            _ = try await invalidService.getCities()
            XCTFail("Expected invalidURL error, but got success response")
        } catch MyErrors.invalidURL {
            // Success
        } catch {
            XCTFail("Unexpected error: \(error) ")
        }
    }
    
    func testGetCities_InvalidResponse() async {
        let jsonData = """
        [
            { "_id": 1, "name": "Buenos Aires", "country": "AR", "coord": { "lon": -58.38, "lat": -34.61 } }
        ]
        """.data(using: .utf8)!
        
        let response = HTTPURLResponse(
            url: URL(string: "https://mockurl.com")!,
            statusCode: 500, // Simulating an error response
            httpVersion: nil,
            headerFields: nil
        )
        
        sessionMock.dataToReturn = jsonData
        sessionMock.responseToReturn = response
        
        do {
            _ = try await cityService.getCities()
            XCTFail("Expected invalidResponse error, but got success response")
        } catch MyErrors.invalidResponse {
            // Success
        } catch {
            XCTFail("Unexpected error: \(error) ")
        }
    }
    
    func testGetCities_InvalidData() async {
        let jsonData = "invalid json".data(using: .utf8)!
        
        let response = HTTPURLResponse(
            url: URL(string: "https://mockurl.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        sessionMock.dataToReturn = jsonData
        sessionMock.responseToReturn = response
        
        do {
            _ = try await cityService.getCities()
            XCTFail("Expected invalidData error, but got success response")
        } catch MyErrors.invalidData {
            // Success
        } catch {
            XCTFail("Unexpected error: \(error) ")
        }
    }
}
