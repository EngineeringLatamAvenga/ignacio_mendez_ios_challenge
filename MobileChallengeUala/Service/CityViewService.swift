//
//  CityViewService.swift
//  MobileChallengeUala
//
//  Created by Nacho Mendez on 06/02/2025.
//

import Foundation

enum MyErrors: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

protocol CityService {
    func getCities() async throws -> [CityModel]
}

class CityViewService: CityService {
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func getCities() async throws -> [CityModel] {
        guard let url = URL(
            string: "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
        ) else {
            throw MyErrors.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MyErrors.invalidResponse
        }

        do {
            return try JSONDecoder().decode([CityModel].self, from: data)
        } catch {
            throw MyErrors.invalidData
        }
    }

}
