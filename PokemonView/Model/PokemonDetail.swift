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
    let cries: Cries
    let height: Int
    let weight: Int
    let sprites: Sprites
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
    let latest, legacy: String
}
