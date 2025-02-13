//
//  CityModel.swift
//  MobileChallengeUala
//
//  Created by Nacho Mendez on 06/02/2025.
//

import Foundation

struct CityModel: Codable, Identifiable, Equatable {
    let country, name: String
    let id: Int
    let coord: Coord
    
    let lowercaseName: String
    
    enum CodingKeys: String, CodingKey {
        case country, name
        case id = "_id"
        case coord
    }
    
    init(country: String, name: String, id: Int, coord: Coord) {
        self.country = country
        self.name = name
        self.id = id
        self.coord = coord
        self.lowercaseName = name.lowercased()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        country = try container.decode(String.self, forKey: .country)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)
        coord = try container.decode(Coord.self, forKey: .coord)
        
        lowercaseName = name.lowercased()
    }
}

struct Coord: Codable, Equatable {
    let lon, lat: Double
}
