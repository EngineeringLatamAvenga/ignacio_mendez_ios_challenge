//
//  SearchView.swift
//  MobileChallengeUala
//
//  Created by Nacho Mendez on 13/02/2025.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @ObservedObject var cityViewModel: CityViewModel
    @State private var searchWorkItem: DispatchWorkItem?

    init(text: Binding<String>, cityViewModel: CityViewModel) {
        _text = text
        self.cityViewModel = cityViewModel
    }

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
