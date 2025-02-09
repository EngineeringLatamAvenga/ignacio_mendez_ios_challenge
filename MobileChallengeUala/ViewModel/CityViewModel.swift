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

    @MainActor
    func fetchCities() async throws {
        Task {
            do {
                cities = try await cityViewService.getCities()
                filterCities() // Filtrar inicialmente con texto vacío o existente
            } catch {
                throw error
            }
        }
    }


    func filterCities() {
        let startTime = Date()

        let lowercasedSearchText = searchText.lowercased()

        filteredCities = cities.filter { city in
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: item) // Espera 1 segundo
    }
}
