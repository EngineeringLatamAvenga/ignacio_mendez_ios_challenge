//
//  CityViewModel.swift
//  MobileChallengeUala
//
//  Created by Nacho Mendez on 06/02/2025.
//

import Foundation
import Combine

protocol CityViewModelProtocol: ObservableObject {
    var cities: [CityModel] { get set }
    var filteredCities: [CityModel] { get set }
    var searchText: String { get set }
    var isLoading: Bool { get set }
    var selectedCity: CityModel? { get set }

    func fetchCities() async throws
    func filterCities()
    func debounceFilterCities()
    func filterByFavorites(showFavorites: Bool)
}

class CityViewModel: ObservableObject, CityViewModelProtocol {

    @Published var cities: [CityModel] = []
    @Published var filteredCities: [CityModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = true
    @Published var selectedCity: CityModel? = nil

    private let cityService: CityService
    private var searchWorkItem: DispatchWorkItem?
    private static var allCities: [CityModel] = []
    private var showFavorites = false

    init(cityService: CityService) {
        self.cityService = cityService
    }


    @MainActor
    func fetchCities() async throws {
        if !CityViewModel.allCities.isEmpty {
            self.cities = CityViewModel.allCities
            filterCities()
            return
        }

        isLoading = true

        do {
            let fetchedCities = try await cityService.getCities()
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
                print("Tiempo de ejecución de filterCities (optimizado): \(executionTime) segundos")
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

class MockCityViewService: CityService {
    func getCities() async throws -> [CityModel] {
        return [
            CityModel(country: "Argentina", name: "Buenos Aires", id: 1, coord: Coord(lon: 1.0, lat: 1.0)),
            CityModel(country: "Argentina", name: "Cordoba", id: 2, coord: Coord(lon: 1.0, lat: 1.0))
        ]
    }
}
