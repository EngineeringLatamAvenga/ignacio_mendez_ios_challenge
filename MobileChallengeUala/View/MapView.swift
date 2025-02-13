//
//  MapView.swift
//  MobileChallengeUala
//
//  Created by Nacho Mendez on 12/02/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    var city: CityModel
    @State private var mapPosition: MapCameraPosition // Agrega el estado para la posición del mapa
    
    init(city: CityModel) {
        self.city = city
        _mapPosition = State(initialValue: .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)))) // Inicializa mapPosition con la ciudad)
    }
    
    var body: some View {
        Map(position: $mapPosition) {
            Marker(city.name, coordinate: CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon))
        }
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: city) { newCity in
            mapPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: newCity.coord.lat, longitude: newCity.coord.lon), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)))
        }
    }
    
    private var coordinateRegion: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
    }
}

#Preview {
    MapView(
        city: CityModel(
            country: "Argentina",
            name: "Buenos Aires",
            id: 3435910,
            coord: Coord(
                lon: -58.381592,
                lat: -34.603722
            )
        )
    )
}
