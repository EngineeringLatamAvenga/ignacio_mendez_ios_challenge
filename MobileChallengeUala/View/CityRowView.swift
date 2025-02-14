//
//  CityRowView.swift
//  MobileChallengeUala
//
//  Created by Nacho Mendez on 07/02/2025.
//

import SwiftUI

struct CityRowView: View {
    var cityModel: CityModel
    @State private var isFavorite: Bool
    @ObservedObject var cityViewModel: CityViewModel
    @Environment(\.scenePhase) var scenePhase
    var horizontal: Bool = false

    init(cityModel: CityModel, cityViewModel: CityViewModel, horizontal: Bool) {
        self.cityModel = cityModel
        _isFavorite = State(initialValue: FavoritesManager.shared.isFavorite(cityId: cityModel.id))
        self.cityViewModel = cityViewModel
        self.horizontal = horizontal
    }

    var body: some View {
        if horizontal {
            Button(action: {
                cityViewModel.selectedCity = cityModel
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(cityModel.name). \(cityModel.country)")
                            .font(.headline)
                        Text("Coordinates: (Lat: \(cityModel.coord.lat), Lon: \(cityModel.coord.lon))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button {
                        isFavorite.toggle()
                        if isFavorite {
                            FavoritesManager.shared.addFavorite(cityId: cityModel.id)
                        } else {
                            FavoritesManager.shared.removeFavorite(cityId: cityModel.id)
                        }
                    } label: {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                }
                .padding()
            }
        } else {
            NavigationLink(destination: MapView(city: cityModel)) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(cityModel.name). \(cityModel.country)")
                            .font(.headline)
                        Text("Coordinates: (Lat: \(cityModel.coord.lat), Lon: \(cityModel.coord.lon))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button {
                        isFavorite.toggle()
                        if isFavorite {
                            FavoritesManager.shared.addFavorite(cityId: cityModel.id)
                        } else {
                            FavoritesManager.shared.removeFavorite(cityId: cityModel.id)
                        }
                    } label: {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                }
                .padding()
            }
        }
    }
}


#Preview {
    CityRowView(
        cityModel: CityModel(
            country: "country",
            name: "name",
            id: 1,
            coord: Coord(
                lon: 1,
                lat: 1
            )
        ), cityViewModel: CityViewModel(cityService: CityViewService()), horizontal: false 
    )
}
