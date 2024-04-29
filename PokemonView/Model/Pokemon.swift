//
//  Pokemon.swift
//  PokemonView
//
//  Created by Stephen Clark on 22/04/2024.
//

import Foundation

// MARK: - Pokemon
struct Pokemon: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [IndividualPokemon]

    init(count: Int, next: String, previous: String, results: [IndividualPokemon]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
    
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
    var id: String { extractPokemonID(from: url) }
    var name: String
    var url: String
    var spriteUrl: String {
        return "\(Constants.API.pokemonSpriteBaseUrl)\(id)\(Constants.API.pokemonSpriteSuffix)"
    }

    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
    
    init(from realmObject: IndividualPokemonRealmObject) {
        self.name = realmObject.name
        self.url = realmObject.url
    }
}


func extractPokemonID(from url: String) -> String {
    let components = url.trimmingCharacters(in: CharacterSet(charactersIn: "/")).split(separator: "/")
    if let lastComponent = components.last {
        return String(lastComponent)
    }
    return ""
}
