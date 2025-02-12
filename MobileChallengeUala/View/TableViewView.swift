//
//  ContentView.swift
//  MobileChallengeUala
//
//  Created by Nacho Mendez on 06/02/2025.
//

import SwiftUI

struct TableViewView: View {

    @ObservedObject private var cityViewModel = CityViewModel()
    @State private var showingFavorites = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    SearchBar(text: $cityViewModel.searchText, cityViewModel: cityViewModel)
                    Button {
                        showingFavorites.toggle()
                        cityViewModel.filterByFavorites(showFavorites: showingFavorites)
                    } label: {
                        Image(systemName: showingFavorites ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                }


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
            }.padding(.top, 10)
            .navigationTitle("Cities")
            .onAppear {
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
    @State private var searchWorkItem: DispatchWorkItem?

    var body: some View {
        TextField("Search", text: $text)
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
            .onChange(of: text) { newText in
                searchWorkItem?.cancel()

                let item = DispatchWorkItem {
                    cityViewModel.isLoading = true
                    cityViewModel.searchText = newText
                    cityViewModel.debounceFilterCities()
                }

                searchWorkItem = item
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: item)
            }
    }
}

#Preview {
    TableViewView()
}
