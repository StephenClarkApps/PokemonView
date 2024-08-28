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

class PokemonRealmObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var count: Int
    @Persisted var next: String?
    @Persisted var previous: String?
    @Persisted var results: List<IndividualPokemonRealmObject>
    @Persisted var metadata: PokemonListMetadata?

    convenience init(from pokemon: Pokemon) {
        self.init()
        self.id = UUID().uuidString
        self.count = pokemon.count
        self.next = pokemon.next
        self.previous = pokemon.previous
        self.results.append(objectsIn: pokemon.results.map { IndividualPokemonRealmObject(from: $0) })
        self.metadata = PokemonListMetadata()
    }

    // Conversion method
    func toPokemon() -> Pokemon {
        return Pokemon(
            count: self.count,
            next: self.next ?? "",
            previous: self.previous ?? "",
            results: self.results.map { $0.toIndividualPokemon() }
        )
    }
}


// MARK: - IndividualPokemon

class IndividualPokemonRealmObject: Object {
    @Persisted(primaryKey: true) var url: String
    @Persisted var name: String
    @Persisted var sprite: String?

    convenience init(from pokemon: IndividualPokemon) {
        self.init()
        self.url = pokemon.url
        self.name = pokemon.name
        self.sprite = pokemon.spriteUrl
    }

    // Conversion method
    func toIndividualPokemon() -> IndividualPokemon {
        return IndividualPokemon(
            name: self.name,
            url: self.url
        )
    }

}
