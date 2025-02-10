//
//  CityModel.swift
//  MobileChallengeUala
//
//  Created by Nacho Mendez on 06/02/2025.
//

import Foundation

struct CityModel: Codable, Identifiable {
    let country, name: String
    let id: Int
    let coord: Coord

    // New properties for lowercase versions
    let lowercaseName: String

    enum CodingKeys: String, CodingKey {
        case country, name
        case id = "_id"
        case coord
    }

    // Designated Initializer - For direct instantiation (e.g., previews, manual creation)
    init(country: String, name: String, id: Int, coord: Coord) {
        self.country = country
        self.name = name
        self.id = id
        self.coord = coord
        self.lowercaseName = name.lowercased()
    }


    // Decoder initializer - to decode from JSON and calculate lowercase properties
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        country = try container.decode(String.self, forKey: .country)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)
        coord = try container.decode(Coord.self, forKey: .coord)

        // Calculate and assign lowercase properties during decoding
        lowercaseName = name.lowercased()
    }
}

struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Favorites Manager
class FavoritesManager {
    static let shared = FavoritesManager()
    private let favoritesKey = "favoriteCities"
    private let userDefaults = UserDefaults.standard

    private init() {}

    func isFavorite(cityId: Int) -> Bool {
        let favorites = userDefaults.array(forKey: favoritesKey) as? [Int] ?? []
        return favorites.contains(cityId)
    }

    func addFavorite(cityId: Int) {
        var favorites = userDefaults.array(forKey: favoritesKey) as? [Int] ?? []
        if !favorites.contains(cityId) {
            favorites.append(cityId)
            userDefaults.set(favorites, forKey: favoritesKey)
        }
    }

    func removeFavorite(cityId: Int) {
        var favorites = userDefaults.array(forKey: favoritesKey) as? [Int] ?? []
        favorites.removeAll { $0 == cityId }
        userDefaults.set(favorites, forKey: favoritesKey)
    }

    func getFavoriteCitiesIds() -> [Int] {
        return userDefaults.array(forKey: favoritesKey) as? [Int] ?? []
    }
}
