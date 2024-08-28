//
//  ContentView.swift
//  PokemonView
//
//  Created by Stephen Clark on 22/04/2024.
//
import SwiftUI

struct PokemonListView: View {
    @ObservedObject var viewModel: PokemonListViewModel // injected from elsewhere so @ObservedObject
    let apiManager: PokemonAPIManagerProtocol
    @State private var searchText: String = ""
    @State private var selectedPokemon: IndividualPokemon?

    var body: some View {
        VStack {
            headerView
            
            searchArea
            
            ScrollViewReader { scrollViewProxy in
                ZStack {
                    pokemonList(scrollViewProxy: scrollViewProxy)
                    
                    scrollToTopButton(scrollViewProxy: scrollViewProxy)
                }
            }
        }
        .onAppear {
            if viewModel.pokemonList.isEmpty {
                viewModel.fetchPokemonList()
            }
        }
    }

    // MARK: - Header View
    private var headerView: some View {
        VStack(alignment: .center, spacing: 5) {
            Image("pokemonLogo")
                .resizable()
                .scaledToFit()
                .padding(.top)
                .frame(width: 200, height: 100)
                .shadow(color: Color("ColorBlackTransparentLight"), radius: 8, x: 0, y: 4)
            
            Text("View")
                .scaledFont(name: "GillSans", size: 30)
                .fontWeight(.bold)
                .foregroundColor(Color("ColorYellowAdaptive"))
                .padding(.top, -10)
        }
        .accessibilityLabel("Pokémon View App Logo")
        .padding()
    }
    
    // MARK: - Search Area
    private var searchArea: some View {
        HStack {
            TextField("Search Pokémon", text: $searchText)
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 40.0)

            if !searchText.isEmpty {
                Button(action: { clearSearch() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .accessibilityLabel("Clear the search field")
            }
        }
        .padding(10)
        .border(Color.gray, width: 1.0)
        .cornerRadius(0)
        .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
        .onChange(of: searchText) { newValue in
            viewModel.searchPokemon(name: newValue)
        }
        .accessibilityLabel("Search Pokémon")
        .accessibilityHint("Enter a Pokémon name to search in the list.")
    }

    // MARK: - Pokemon List View
    private func pokemonList(scrollViewProxy: ScrollViewProxy) -> some View {
        List(viewModel.filteredPokemon, id: \.id) { pokemon in
            HStack {
                CustomAsyncImage(url: URL(string: pokemon.spriteUrl)!) {
                    ProgressView()
                }
                .frame(width: 55, height: 55)
                .cornerRadius(25)
                
                Text(pokemon.name.capitalized)
                    .modifier(AdaptiveText())
                Spacer()
            }
            .background(Color.clear) // Fix issue with capturing taps
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
    }

    // MARK: - Scroll to Top Button
    private func scrollToTopButton(scrollViewProxy: ScrollViewProxy) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button("Scroll to Top") {
                    if let firstId = viewModel.filteredPokemon.first?.id {
                        scrollViewProxy.scrollTo(firstId, anchor: .top)
                    }
                }
                .accessibilityLabel("Scroll to the top of the List of Pokemon")
                .frame(height: 30.0)
                .padding(5)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 3)
                .padding()
            }
        }
    }

    // MARK: - Helper Functions
    private func clearSearch() {
        searchText = ""
        hideKeyboard()
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Preview
struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        let realmProvider = DefaultRealmProvider()
        let cacheManager = PokemonCacheManager(realmProvider: realmProvider)
        let apiManager = APIManager(cacheManager: cacheManager)
        let viewModel = PokemonListViewModel(apiManager: apiManager, dataStore: PokemonDataStore())
        
        PokemonListView(viewModel: viewModel, apiManager: apiManager)
    }
}
