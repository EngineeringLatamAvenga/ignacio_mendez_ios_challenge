//
//  FavoriteManager.swift
//  MobileChallengeUala
//
//  Created by Nacho Mendez on 13/02/2025.
//

import Foundation

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
