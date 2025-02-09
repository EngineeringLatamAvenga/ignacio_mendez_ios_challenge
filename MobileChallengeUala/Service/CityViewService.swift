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

class CityViewService {
    func getCities() async throws -> [CityModel]  {
        guard let url = URL(
            string: "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
        ) else {
            throw MyErrors.invalidURL
        }
        
        do {
            let(data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw MyErrors.invalidResponse
            }
            
            let decodedData = try JSONDecoder().decode([CityModel].self, from: data)
            return decodedData
        } catch {
            throw MyErrors.invalidData
        }
    }
}
