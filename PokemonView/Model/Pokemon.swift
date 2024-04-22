//
//  Pokemon.swift
//  PokemonView
//
//  Created by Stephen Clark on 22/04/2024.
//

import Foundation

// Start with some default model without referencing the json data for the actual
// structure of the structs

struct Pokemon: Identifiable {
    let id: Int
    let name: String
    let sprites: [String: String]
    
    init(name: String, sprites: [String: String]) {
        self.id = UUID().hashValue
        self.name = name
        self.sprites = sprites
    }
}

struct PokemonDetail {
    let stats: [Stat]
}

struct Stat {
    let name: String
    let baseStat: Int
}
