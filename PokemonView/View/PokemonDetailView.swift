//
//  PokemonDetailView.swift
//  PokemonView
//
//  Created by Stephen Clark on 24/04/2024.
//

import SwiftUI
import Foundation

struct PokemonDetailView: View {
    @ObservedObject var viewModel: PokemonDetailViewModel
    let pokemonURL: String
    
    var body: some View {
        Group {
            if let details = viewModel.pokemonDetail {
                VStack {
                    Text("Name: \(details.name)")
                    // Display other details
                }
            } else {
                Text("Loading...")
                    .onAppear {
                        viewModel.loadPokemonDetails(from: pokemonURL)
                    }
            }
        }
    }
}
