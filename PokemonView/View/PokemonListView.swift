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
    @State private var selectedPokemon: IndividualPokemon?

    var body: some View {
        VStack {
            Text("Pokedex")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .accessibilityAddTraits(.isHeader) 

            TextField("Search Pokémon", text: $searchText)
                .padding()
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: searchText) { newValue in
                    viewModel.searchPokemon(name: newValue)
                }
                .accessibilityLabel("Search Pokémon")
                .accessibilityHint("Enter a Pokémon name to search in the list.")

            List(viewModel.filteredPokemon, id: \.self) { pokemon in
                Button(action: {
                    self.selectedPokemon = pokemon
                }) {
                    Text(pokemon.name.capitalized)
                        .modifier(AdaptiveText())
                }
                .accessibilityLabel("\(pokemon.name.capitalized), tap for details")
                .accessibilityHint("Double-tap to view more details about \(pokemon.name.capitalized)")
                .onAppear {
                    if pokemon == viewModel.filteredPokemon.last && viewModel.hasMoreData {
                        viewModel.fetchPokemonList()
                    }
                }
            }
            .sheet(item: $selectedPokemon) { pokemon in
                PokemonDetailView(viewModel: PokemonDetailViewModel(apiManager: apiManager), pokemonURL: pokemon.url)
            }
        }
        .onAppear {
            if viewModel.pokemonList.isEmpty {
                viewModel.fetchPokemonList()
            }
        }
    }
}


let apiManForPrev = APIManager()
#Preview {
    PokemonListView(viewModel: PokemonListViewModel(apiManager: apiManForPrev), apiManager: apiManForPrev)
}

