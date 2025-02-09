//
//  CityRowView.swift
//  MobileChallengeUala
//
//  Created by Nacho Mendez on 07/02/2025.
//

import SwiftUI

struct CityRowView: View {
    var cityModel: CityModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(cityModel.id). \(cityModel.name)")
                .font(.headline)
            Text("Country: \(cityModel.country)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Coordinates: (Lat: \(cityModel.coord.lat), Lon: \(cityModel.coord.lon))")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
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
        )
    )
}
