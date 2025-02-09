//
//  ContentView.swift
//  MobileChallengeUala
//
//  Created by Nacho Mendez on 06/02/2025.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject private var cityViewModel = CityViewModel()

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $cityViewModel.searchText, cityViewModel: cityViewModel)

                if cityViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(2.0, anchor: .center)
                        .padding(.top, 20)
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(cityViewModel.filteredCities) { city in
                                CityRowView(cityModel: city)
                            }
                        }
                    }
                }
                Spacer()
            }.onAppear {
                Task {
                    do {
                        try await cityViewModel.fetchCities()
                    } catch {
                        print("error")
                    }
                }
            }
        }
    }
}

// Barra de búsqueda
struct SearchBar: View {
    @Binding var text: String
    @ObservedObject var cityViewModel: CityViewModel
    @State private var searchWorkItem: DispatchWorkItem? // Work item for delay in SearchBar

    var body: some View {
        TextField("Search", text: $text)
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
            .onChange(of: text) { newText in
                searchWorkItem?.cancel() // Cancela cualquier trabajo previo en SearchBar

                let item = DispatchWorkItem {
                    cityViewModel.isLoading = true
                    cityViewModel.searchText = newText // Actualiza searchText en CityViewModel
                    cityViewModel.debounceFilterCities() // Llama a la función debounced en CityViewModel
                }

                searchWorkItem = item // Guarda el nuevo work item en SearchBar
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: item) // Espera 0.5 segundos en SearchBar - Reduced delay
            }
    }
}

#Preview {
    ContentView()
}
