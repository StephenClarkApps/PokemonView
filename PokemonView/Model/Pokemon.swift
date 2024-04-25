//
//  Pokemon.swift
//  PokemonView
//
//  Created by Stephen Clark on 22/04/2024.
//

import Foundation

// MARK: - Pokemon
struct Pokemon: Codable, Hashable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [IndividualPokemon]
}

// MARK: - IndividualPokemon
struct IndividualPokemon: Codable, Hashable, Identifiable {
    var id: String { url }
    let name: String
    let url: String
}

