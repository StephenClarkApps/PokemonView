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
            // MARK: - HEADER
            VStack(alignment: .center, spacing: 5) {
                Image("pokemonLogo")
                    .resizable()
                    .scaledToFit()
                    .padding(.top)
                    .frame(width: 200, height: 100, alignment: .center)
                    .shadow(color: Color("ColorBlackTransparentLight"), radius: 8, x: 0, y: 4)
                
                Text("View")
                    .scaledFont(name: "GillSans", size: 30)
                    .fontWeight(.bold)
                    .foregroundColor(Color("ColorYellowAdaptive"))
                    .padding(.top, -10)
            } //: VSTACK
            .accessibilityLabel("Pokémon View App Logo")
            .padding()
            
            // MARK: - SEARCH AREA
            HStack {
                TextField("Search Pokémon", text: $searchText)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: { searchText = ""; hideKeyboard()}) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            } //: HSTACK
            .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
            .onChange(of: searchText) { newValue in
                viewModel.searchPokemon(name: newValue)
            }
            .accessibilityLabel("Search Pokémon")
            .accessibilityHint("Enter a Pokémon name to search in the list.")
            
            // MARK: - LIST OF POKÉMON
            List(viewModel.filteredPokemon, id: \.self) { pokemon in
                Button(action: {
                    self.selectedPokemon = pokemon
                }) {
                    HStack {
                        Image("icnPokemon").resizable().frame(width: 40, height: 40, alignment: .leading).padding().border(.black, width: 2.0)
                        Spacer().frame(width: 10)
                        Text(pokemon.name.capitalized)
                            .modifier(AdaptiveText())
                    }
                }
                .accessibilityLabel("\(pokemon.name.capitalized), tap for details")
                .accessibilityHint("Double-tap to view more details about \(pokemon.name.capitalized)")
                .onAppear {
                    if pokemon == viewModel.filteredPokemon.last && viewModel.hasMoreData {
                        viewModel.fetchPokemonList()
                    }
                }
            } //: LIST
            .sheet(item: $selectedPokemon) { pokemon in
                PokemonDetailView(viewModel: PokemonDetailViewModel(apiManager: apiManager), pokemonURL: pokemon.url)
            }
        } //: VSTACK
        .onAppear {
            if viewModel.pokemonList.isEmpty {
                viewModel.fetchPokemonList()
            }
        }
    } //: VIEW
    
    // MARK: - HELPER FUNCTIONS
    
    // Helper function to hide the keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


let apiManForPrev = APIManager()
#Preview {
    PokemonListView(viewModel: PokemonListViewModel(apiManager: apiManForPrev), apiManager: apiManForPrev)
}

