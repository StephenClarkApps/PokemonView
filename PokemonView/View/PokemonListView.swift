//
//  ContentView.swift
//  PokemonView
//
//  Created by Stephen Clark on 22/04/2024.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject var viewModel: PokemonListViewModel
    let apiManager: PokemonAPIManagerProtocol
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
                    .frame(height: 40.0)

                
                if !searchText.isEmpty {
                    Button(action: { searchText = ""; hideKeyboard()}) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .accessibilityLabel("Clear the search field")
                }
            } //: HSTACK
            .padding(10)
            .border(Color.gray, width: 1.0)
            .cornerRadius(0)
            .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
            .onChange(of: searchText) { newValue in
                viewModel.searchPokemon(name: newValue)
            }
            .accessibilityLabel("Search Pokémon")
            .accessibilityHint("Enter a Pokémon name to search in the list.")
            
            ScrollViewReader { scrollViewProxy in
                ZStack {
                    List(viewModel.filteredPokemon, id: \.id) { pokemon in
                        HStack {
                            CustomAsyncImage(url: URL(string: pokemon.spriteUrl)!) {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)
                            .cornerRadius(20)

                            Text(pokemon.name.capitalized)
                                .modifier(AdaptiveText())
                        }
                        .onTapGesture {
                            selectedPokemon = pokemon
                        }
                    }
                    .refreshable {
                        viewModel.clearCacheAndFetchPokemonList()
                    }
                    .sheet(item: $selectedPokemon) { pokemon in
                        PokemonDetailView(viewModel: PokemonDetailViewModel(apiManager: apiManager), pokemonURL: pokemon.url)
                    }

                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button("Scroll to Top") {
                                scrollViewProxy.scrollTo(0, anchor: .top)
                            }
                            .accessibilityLabel("Scroll to the top of the List of Pokemon")
                            .padding(5)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                            .padding()
                        }//: HStack
                    }
                }
            } //: ScrollViewReader
        } //: VSTACK
        .onAppear {
            if viewModel.pokemonList.isEmpty { //|| apiManager.isCacheExpired() {
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



let realmProvider = DefaultRealmProvider()
let cacheManager = PokemonCacheManager(realmProvider: realmProvider)
let apiManForPrev = APIManager(cacheManager: cacheManager)
#Preview {
    PokemonListView(viewModel: PokemonListViewModel(apiManager: apiManForPrev), apiManager: apiManForPrev)
}

