//
//  PokemonDetail.swift
//  PokemonView
//
//  Created by Stephen Clark on 22/04/2024.
//

import Foundation

// We can use a resource like https://app.quicktype.io/ but we don't need everything
// (we pipe in the response we get using Postman into the site to get that)
// it gives us, so we can simplify it a lot to just give us what we need to use

// MARK: - PokemonDetail
struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let cries: Cries?
    let height: Int
    let weight: Int
    let sprites: Sprites?
    let stats: [Stat]
    let types: [TypeElement]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case cries
        case height
        case weight
        case sprites
        case stats
        case types
    }

    // Convenience initializer to create a PokemonDetail from a PokemonDetailRealmObject
    init(from realmObject: PokemonDetailRealmObject) {
        self.id = realmObject.id
        self.name = realmObject.name
        self.cries = Cries(latest: realmObject.cries?.latest ?? "", legacy: realmObject.cries?.legacy ?? "")
        self.height = realmObject.height
        self.weight = realmObject.weight
        self.sprites = Sprites(frontDefault: realmObject.sprites?.frontDefault ?? "",
                               backDefault: realmObject.sprites?.backDefault ?? "")
        
        // Mapping stats
        self.stats = realmObject.stats.compactMap { statObject in
            guard let stat = statObject.stat else {
                return Stat(baseStat: 0, stat: Species(name: "One", url: "http://www.google.com"))
            }
            return Stat(baseStat: statObject.baseStat, stat: Species(name: stat.name, url: stat.url))
        }
                
        self.types = realmObject.types.compactMap { typeObject in
            guard let type = typeObject.type else {
                return TypeElement(slot: 0, type: Species(name: "One", url: "http://www.google.com"))
            }
            return TypeElement(slot: typeObject.slot, type: Species(name: type.name, url: type.url))
        }

    }


}


// MARK: - Sprites
struct Sprites: Codable {
    let frontDefault: String
    let backDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case backDefault = "back_default"
    }
}

// MARK: - Stat
struct Stat: Codable {
    let baseStat: Int
    let stat: Species
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let slot: Int
    let type: Species
}

// MARK: - Species
struct Species: Codable {
    let name: String
    let url: String
}

// MARK: - Cries
struct Cries: Codable {
    let latest, legacy: String?
}
