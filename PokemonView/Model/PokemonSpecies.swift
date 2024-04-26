//
//  PokemonSpecies.swift
//  PokemonView
//
//  Created by Stephen Clark on 25/04/2024.
//

import Foundation

// Looking at a species endpoint https://pokeapi.co/api/v2/pokemon-species/132/ running it through
// https://app.quicktype.io/ we get to this (with some tweaks)


// MARK: - PokemonSpecies
struct PokemonSpecies: Codable, Hashable {
    let baseHappiness, captureRate: Int?
    let color: NameAndUrl?
    let eggGroups: [NameAndUrl]?
    let evolutionChain: EvolutionChain?
    let evolvesFromSpecies: String?
    let flavorTextEntries: [FlavorTextEntry]?
    let formDescriptions: [String?]?
    let formsSwitchable: Bool?
    let genderRate: Int?
    let genera: [Genus]?
    let generation, growthRate, habitat: NameAndUrl?
    let hasGenderDifferences: Bool?
    let hatchCounter, id: Int?
    let isBaby, isLegendary, isMythical: Bool?
    let name: String?
    let names: [Name]?
    let order: Int?
    let palParkEncounters: [PalParkEncounter]?
    let pokedexNumbers: [PokedexNumber]?
    let shape: NameAndUrl?
    let varieties: [Variety]?
}

// MARK: - Color
struct NameAndUrl: Codable, Hashable {
    let name: String?
    let url: String?
}

// MARK: - EvolutionChain
struct EvolutionChain: Codable, Hashable {
    let url: String?
}

// MARK: - FlavorTextEntry
struct FlavorTextEntry: Codable, Hashable {
    let flavorText: String?
    let language, version: NameAndUrl?
}

// MARK: - Genus
struct Genus: Codable, Hashable {
    let genus: String?
    let language: NameAndUrl?
}

// MARK: - Name
struct Name: Codable, Hashable {
    let language: NameAndUrl?
    let name: String?
}

// MARK: - PalParkEncounter
struct PalParkEncounter: Codable, Hashable {
    let area: NameAndUrl?
    let baseScore, rate: Int?
}

// MARK: - PokedexNumber
struct PokedexNumber: Codable, Hashable {
    let entryNumber: Int?
    let pokedex: NameAndUrl?
}

// MARK: - Variety
struct Variety: Codable, Hashable {
    let isDefault: Bool?
    let pokemon: NameAndUrl?
}
