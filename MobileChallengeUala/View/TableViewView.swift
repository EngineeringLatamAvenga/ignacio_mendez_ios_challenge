//
//  ContentView.swift
//  MobileChallengeUala
//
//  Created by Nacho Mendez on 06/02/2025.
//

import SwiftUI
import UIKit

struct TableViewView: View {
    @ObservedObject private var cityViewModel = CityViewModel()
    @State private var showingFavorites = false
    @Environment(\.scenePhase) var scenePhase
    @State private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                if isLandscape  { // Horizontal
                    HStack {
                        VStack {
                            SearchBar(text: $cityViewModel.searchText, cityViewModel: cityViewModel)
                            FavoriteButton(showingFavorites: $showingFavorites, cityViewModel: cityViewModel)
                            CityList(cityViewModel: cityViewModel, horizontal: true)
                        }
                        .frame(width: geometry.size.width / 2)
                        .padding(.top, 10)
                        .navigationTitle("Cities")
                        .onAppear { fetchCities(cityViewModel: cityViewModel) }

                        if let selectedCity = cityViewModel.selectedCity {
                            MapView(city: selectedCity)
                                .frame(width: geometry.size.width / 2)
                        } else {
                            Text("Select a city to view on the map")
                                .frame(width: geometry.size.width / 2)
                        }
                    }
                } else { // Vertical
                    VStack {
                        SearchBar(text: $cityViewModel.searchText, cityViewModel: cityViewModel)
                        FavoriteButton(showingFavorites: $showingFavorites, cityViewModel: cityViewModel)
                        CityList(cityViewModel: cityViewModel, horizontal: false)
                    }
                    .padding(.top, 10)
                    .navigationTitle("Cities")
                    .onAppear { fetchCities(cityViewModel: cityViewModel) }
                }
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                // Puedes agregar lógica adicional aquí si es necesario
            }
        }
        .onAppear { // ✅ Añade .onAppear y .onDisappear para la notificación
            NotificationCenter.default.addObserver(
                forName: UIDevice.orientationDidChangeNotification,
                object: nil,
                queue: .main
            ) { _ in
                self.isLandscape = UIDevice.current.orientation.isLandscape
            }
            self.isLandscape = UIDevice.current.orientation.isLandscape // Orientación inicial
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        }
    }


    private func fetchCities(cityViewModel: CityViewModel) {
        Task {
            do {
                try await cityViewModel.fetchCities()
            } catch {
                print("error")
            }
        }
    }
}

struct FavoriteButton: View {
    @Binding var showingFavorites: Bool
    @ObservedObject var cityViewModel: CityViewModel

    var body: some View {
        Button {
            showingFavorites.toggle()
            cityViewModel.filterByFavorites(showFavorites: showingFavorites)
        } label: {
            Image(systemName: showingFavorites ? "heart.fill" : "heart")
                .foregroundColor(.red)
        }
        .padding(.horizontal)
    }
}

struct CityList: View {
    @ObservedObject var cityViewModel: CityViewModel
    var horizontal: Bool

    var body: some View {
        if cityViewModel.isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(2.0, anchor: .center)
                .padding(.top, 20)
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(cityViewModel.filteredCities) { city in
                        CityRowView(cityModel: city, cityViewModel: cityViewModel, horizontal: horizontal)
                    }
                }
            }
        }
        Spacer()
    }
}

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
