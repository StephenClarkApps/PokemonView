//
//  PokemonRealmObject.swift
//  PokemonView
//
//  Created by Stephen Clark on 29/04/2024.
//

import Foundation
import RealmSwift

// MARK: - Pokemon
class PokemonListMetadata: Object {
    @Persisted var createdAt: Date = Date()
}

// MARK: - Pokemon
class PokemonRealmObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var count: Int
    @Persisted var next: String?
    @Persisted var previous: String?
    let results = List<IndividualPokemonRealmObject>()
    @Persisted var metadata: PokemonListMetadata? // Link to metadata object

    // Convenience initializer to create a PokemonRealmObject from a Pokemon
    convenience init(from pokemon: Pokemon) {
        self.init()
        self.id = UUID().uuidString // Example: generate a UUID as the primary key
        self.count = pokemon.count
        self.next = pokemon.next
        self.previous = pokemon.previous
        self.results.append(objectsIn: pokemon.results.map { IndividualPokemonRealmObject(from: $0) })
    }
}

// MARK: - IndividualPokemon
class IndividualPokemonRealmObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var url: String

    // Convenience initializer to create an IndividualPokemonRealmObject from an IndividualPokemon
    convenience init(from individualPokemon: IndividualPokemon) {
        self.init()
        self.id = individualPokemon.id
        self.name = individualPokemon.name
        self.url = individualPokemon.url
    }
}
