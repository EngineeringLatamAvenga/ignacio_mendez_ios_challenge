//
//  CityListView.swift
//  MobileChallengeUala
//
//  Created by Nacho Mendez on 13/02/2025.
//

import SwiftUI

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

