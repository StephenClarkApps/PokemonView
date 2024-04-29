//
//  Constants.swift
//  PokemonView
//
//  Created by Stephen Clark on 22/04/2024.
//

import Foundation

struct Constants {
    
    struct UI {
        static let imageFadeInTime = 0.3
    }
    
    struct API {
        
        static let baseURL = "https://pokeapi.co/api/v2/"
        static let pokemonSpriteBaseUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
        static let pokemonSpriteSuffix = ".png"
        
        enum Endpoints {
            // Endpoint is paged, will choose whether to load in time or all at once
            static let pokemonList = "pokemon"
            static let pokemonListNoLim = "pokemon?limit=2000"
        }
    }
}
