//
//  ContentView.swift
//  PokemonView
//
//  Created by Stephen Clark on 24/04/2024.
//

import SwiftUI
import Foundation

struct ContentView: View {
    
    // TODO: - Inject dependency
    let apiManager = APIManager(cacheManager: PokemonCacheManager(realmProvider: DefaultRealmProvider()))

    var body: some View {
        TabView {
            PokemonListView(viewModel: PokemonListViewModel(apiManager: apiManager, dataStore: PokemonDataStore()), apiManager: apiManager)
                .tabItem {
                    Image("icnPokemon").renderingMode(.template)
                    Text("Pokemon")
                }
                .tag(1)
            
            AboutView()
                .tabItem {
                    Image("icnAbout").renderingMode(.template)
                    Text("About")
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
