//
//  CityViewModel.swift
//  MobileChallengeUala
//
//  Created by Nacho Mendez on 06/02/2025.
//

import Foundation
import Combine // Import Combine for DispatchWorkItem

class CityViewModel: ObservableObject {

    @Published var cities: [CityModel] = []
    @Published var filteredCities: [CityModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = true // Nueva variable para el estado de carga
    var cityViewService = CityViewService()
    private var searchWorkItem: DispatchWorkItem? // Para el debounce
    private static var allCities: [CityModel] = [] // Static property to hold all cities

    @MainActor
    func fetchCities() async throws {
        if !CityViewModel.allCities.isEmpty { // Check if cities are already loaded
            self.cities = CityViewModel.allCities // Load from static property
            filterCities()
            return
        }

        isLoading = true // Start loading before fetching

        Task {
            do {
                let fetchedCities = try await cityViewService.getCities()
                CityViewModel.allCities = fetchedCities // Store fetched cities in static property
                self.cities = fetchedCities // Update published property
                filterCities() // Filtrar inicialmente con texto vacío o existente
            } catch {
                isLoading = false // Stop loading even on error
                throw error
            }
        }
    }


    func filterCities() {
        let startTime = Date()

        let lowercasedSearchText = searchText.lowercased()

        filteredCities = CityViewModel.allCities.filter { city in // Filter from allCities
            city.lowercaseName.hasPrefix(lowercasedSearchText)
        }.sorted { $0.lowercaseName < $1.lowercaseName }

        let endTime = Date()
        let executionTime = endTime.timeIntervalSince(startTime)
        print("Tiempo de ejecución de filterCities (optimizado): \(executionTime) segundos")
        self.isLoading = false // Desactivar el indicador de carga al finalizar el filtrado
    }

    // Función debounced para filtrar ciudades
    func debounceFilterCities() {
        searchWorkItem?.cancel() // Cancela cualquier trabajo previo

        isLoading = true // Activar el indicador de carga antes de comenzar el filtrado

        let item = DispatchWorkItem { [weak self] in
            self?.filterCities() // Llama a la función de filtrado después del delay
        }

        searchWorkItem = item // Guarda el nuevo work item
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: item) // Espera 0.3 segundos - Reduced delay
    }
}
