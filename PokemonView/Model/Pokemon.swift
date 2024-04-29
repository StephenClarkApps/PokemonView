//
//  Pokemon.swift
//  PokemonView
//
//  Created by Stephen Clark on 22/04/2024.
//

import Foundation

// MARK: - Pokemon
struct Pokemon: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [IndividualPokemon]

    // Convenience initializer to create a Pokemon from a PokemonRealmObject
    init(from realmObject: PokemonRealmObject) {
        self.count = realmObject.count
        self.next = realmObject.next
        self.previous = realmObject.previous
        self.results = realmObject.results.map { IndividualPokemon(from: $0) }
    }
}

// MARK: - IndividualPokemon
struct IndividualPokemon: Codable, Identifiable, Hashable {
    var id: String { url }
    let name: String
    let url: String

    // Convenience initializer to create an IndividualPokemon from an IndividualPokemonRealmObject
    init(from realmObject: IndividualPokemonRealmObject) {
        self.name = realmObject.name
        self.url = realmObject.url
    }
}
