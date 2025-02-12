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
    
    var body: some View {
        Map(initialPosition: .region(coordinateRegion)) {
            Marker(city.name, coordinate: CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon))
        }
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.inline)
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
