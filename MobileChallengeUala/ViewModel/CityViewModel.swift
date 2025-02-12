//
//  CityViewModel.swift
//  MobileChallengeUala
//
//  Created by Nacho Mendez on 06/02/2025.
//

import Foundation
import Combine

class CityViewModel: ObservableObject {

    @Published var cities: [CityModel] = []
    @Published var filteredCities: [CityModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = true
    var cityViewService = CityViewService()
    private var searchWorkItem: DispatchWorkItem?
    private static var allCities: [CityModel] = []
    private var showFavorites = false


    @MainActor
    func fetchCities() async throws {
        if !CityViewModel.allCities.isEmpty {
            self.cities = CityViewModel.allCities
            filterCities()
            return
        }

        isLoading = true

        do {
            let fetchedCities = try await cityViewService.getCities()
            CityViewModel.allCities = fetchedCities
            self.cities = fetchedCities
            filterCities()
        } catch {
            isLoading = false
            throw error
        }
    }

    func filterCities() {
        let startTime = Date()

        let lowercasedSearchText = searchText.lowercased()
        let favoriteCityIds = FavoritesManager.shared.getFavoriteCitiesIds()

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            let baseCities = self.showFavorites ? CityViewModel.allCities.filter { favoriteCityIds.contains($0.id) } : CityViewModel.allCities

            let filtered = baseCities.filter { city in
                city.lowercaseName.hasPrefix(lowercasedSearchText)
            }.sorted { $0.lowercaseName < $1.lowercaseName }

            DispatchQueue.main.async {
                self.filteredCities = filtered
                self.isLoading = false
                let endTime = Date()
                let executionTime = endTime.timeIntervalSince(startTime)
            }
        }
    }

    func debounceFilterCities() {
        isLoading = true
        searchWorkItem?.cancel()

        let item = DispatchWorkItem { [weak self] in
            self?.filterCities()
        }

        searchWorkItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: item)
    }

    func filterByFavorites(showFavorites: Bool) {
        self.showFavorites = showFavorites
        filterCities()
    }
}
