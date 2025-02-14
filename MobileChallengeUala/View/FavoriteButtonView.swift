//
//  FavoriteButtonView.swift
//  MobileChallengeUala
//
//  Created by Nacho Mendez on 13/02/2025.
//

import Foundation
import SwiftUI

struct FavoriteButton: View {
    @Binding var showingFavorites: Bool
    @ObservedObject var cityViewModel: CityViewModel

    init(showingFavorites: Binding<Bool>, cityViewModel: CityViewModel) {
        self._showingFavorites = showingFavorites
        self.cityViewModel = cityViewModel
    }

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
