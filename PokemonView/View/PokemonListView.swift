//
//  ContentView.swift
//  PokemonView
//
//  Created by Stephen Clark on 22/04/2024.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject var viewModel: PokemonListViewModel
    let apiManager: APIManagerProtocol
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search Pokémon", text: $searchText, onCommit: {
                    viewModel.searchPokemon(name: searchText)
                })
                .accessibilityLabel("Search Pokémon")
                .accessibilityHint("Enter a Pokémon name to search in the list.")
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

                List(viewModel.filteredPokemon, id: \.self) { pokemon in
                    NavigationLink(destination: PokemonDetailView(viewModel: PokemonDetailViewModel(apiManager: apiManager),
                                                                  pokemonURL: pokemon.url)) {
                        Text(pokemon.name.capitalized)
                            .font(.system(size: 18, weight: .medium, design: .default))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    .accessibilityLabel("\(pokemon.name.capitalized), tap to view details")
                    .accessibilityHint("Double-tap to view more details about \(pokemon.name.capitalized)")
                    .onAppear {
                        if pokemon == viewModel.filteredPokemon.last {
                            viewModel.fetchPokemonList()
                        }
                    }
                } // :List
                .navigationTitle("Pokémon List")
            } //: VStack
        } // :NavigationView
        .onAppear {
            viewModel.fetchPokemonList()
        }
    }

    private func loadPokemonDetailsIfNeeded(_ pokemon: IndividualPokemon) {
        if viewModel.pokemonDetails == nil || viewModel.pokemonDetails?.name != pokemon.name {
            viewModel.fetchAndStorePokemonDetails(url: pokemon.url)
        }
    }
}

let apiManForPrev = APIManager()
#Preview {
    PokemonListView(viewModel: PokemonListViewModel(apiManager: apiManForPrev), apiManager: apiManForPrev)
}
