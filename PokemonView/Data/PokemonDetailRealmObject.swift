//
//  PokemonDetailRealmObject.swift
//  PokemonView
//
//  Created by Stephen Clark on 29/04/2024.
//

import Foundation
import RealmSwift

// Object to store metadata about the cached Pokemon detail
class PokemonDetailMetadata: Object {
    @Persisted var createdAt: Date = Date()
}

// MARK: - PokemonDetail
class PokemonDetailRealmObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var cries: CriesRealmObject?
    @Persisted var height: Int
    @Persisted var weight: Int
    @Persisted var sprites: SpritesRealmObject?
    @Persisted var stats: List<StatRealmObject>
    @Persisted var types: List<TypeElementRealmObject>
    @Persisted var metadata: PokemonDetailMetadata? // Link to metadata object
    
    // Convenience initializer to create a PokemonDetailRealmObject from a PokemonDetail
    convenience init(from pokemonDetail: PokemonDetail) {
        self.init()
        self.id = pokemonDetail.id
        self.name = pokemonDetail.name
        self.cries = CriesRealmObject(from: pokemonDetail.cries ?? Cries(latest: "NADA", legacy: "NADA"))
        self.height = pokemonDetail.height
        self.weight = pokemonDetail.weight
        self.sprites = SpritesRealmObject(from: pokemonDetail.sprites ?? Sprites(frontDefault: "NADA", backDefault: "NADA"))
        self.stats.append(objectsIn: pokemonDetail.stats.map { StatRealmObject(from: $0) })
        self.types.append(objectsIn: pokemonDetail.types.map { TypeElementRealmObject(from: $0) })
    }
}

// MARK: - Sprites
class SpritesRealmObject: Object {
    @Persisted var frontDefault: String
    @Persisted var backDefault: String?
    
    // Convenience initializer to create a SpritesRealmObject from a Sprites
    convenience init(from sprites: Sprites) {
        self.init()
        self.frontDefault = sprites.frontDefault
        self.backDefault = sprites.backDefault
    }
}

// MARK: - Stat
class StatRealmObject: Object {
    @Persisted var baseStat: Int
    @Persisted var stat: SpeciesRealmObject?
    
    // Convenience initializer to create a StatRealmObject from a Stat
    convenience init(from stat: Stat) {
        self.init()
        self.baseStat = stat.baseStat
        self.stat = SpeciesRealmObject(from: stat.stat)
    }
}



// MARK: - TypeElement
class TypeElementRealmObject: Object {
    @Persisted var slot: Int
    @Persisted var type: SpeciesRealmObject?
    
    // Convenience initializer to create a TypeElementRealmObject from a TypeElement
    convenience init(from typeElement: TypeElement) {
        self.init()
        self.slot = typeElement.slot
        self.type = SpeciesRealmObject(from: typeElement.type)
    }
}

// MARK: - Species
class SpeciesRealmObject: Object {
    @Persisted var name: String
    @Persisted var url: String
    
    // Convenience initializer to create a SpeciesRealmObject from a Species
    convenience init(from species: Species) {
        self.init()
        self.name = species.name
        self.url = species.url
    }
}

// MARK: - Cries
class CriesRealmObject: Object {
    @Persisted var latest: String?
    @Persisted var legacy: String?
    
    // Convenience initializer to create a CriesRealmObject from a Cries
    convenience init(from cries: Cries) {
        self.init()
        self.latest = cries.latest
        self.legacy = cries.legacy
    }
}
