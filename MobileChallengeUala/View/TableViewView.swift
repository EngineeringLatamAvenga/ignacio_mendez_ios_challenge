//
//  ContentView.swift
//  MobileChallengeUala
//
//  Created by Nacho Mendez on 06/02/2025.
//

import SwiftUI
import UIKit

struct TableViewView: View {
    @ObservedObject private var cityViewModel: CityViewModel
    @State private var showingFavorites = false
    @Environment(\.scenePhase) var scenePhase
    @State private var isLandscape: Bool = UIDevice.current.orientation.isLandscape

    init(cityViewModel: CityViewModel = CityViewModel(cityService: CityViewService())) {
        _cityViewModel = ObservedObject(wrappedValue: cityViewModel)
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                if isLandscape  {
                    HStack {
                        VStack {
                            SearchBar(text: $cityViewModel.searchText, cityViewModel: cityViewModel)
                            FavoriteButton(showingFavorites: $showingFavorites, cityViewModel: cityViewModel)
                            CityList(cityViewModel: cityViewModel, horizontal: true)
                        }
                        .frame(width: geometry.size.width / 2)
                        .padding(.top, 10)
                        .navigationTitle("Cities")
                        .onAppear { fetchCities() }

                        if let selectedCity = cityViewModel.selectedCity {
                            MapView(city: selectedCity)
                                .frame(width: geometry.size.width / 2)
                        } else {
                            Text("Select a city to view on the map")
                                .frame(width: geometry.size.width / 2)
                        }
                    }
                } else {
                    VStack {
                        SearchBar(text: $cityViewModel.searchText, cityViewModel: cityViewModel)
                        FavoriteButton(showingFavorites: $showingFavorites, cityViewModel: cityViewModel)
                        CityList(cityViewModel: cityViewModel, horizontal: false)
                    }
                    .padding(.top, 10)
                    .navigationTitle("Cities")
                    .onAppear { fetchCities() }
                }
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: UIDevice.orientationDidChangeNotification,
                object: nil,
                queue: .main
            ) { _ in
                self.isLandscape = UIDevice.current.orientation.isLandscape
            }
            self.isLandscape = UIDevice.current.orientation.isLandscape
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        }
    }

    private func fetchCities() {
        Task {
            do {
                try await cityViewModel.fetchCities()
            } catch {
                print("error")
            }
        }
    }
}

#Preview {
    TableViewView(cityViewModel: CityViewModel(cityService: MockCityViewService()))
}
