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
    let baseHappiness, captureRate: Int
    let color: Color
    let eggGroups: [Color]
    let evolutionChain: EvolutionChain
    let evolvesFromSpecies: String?
    let flavorTextEntries: [FlavorTextEntry] // We'll need this if we want to show the flavour text
    let formDescriptions: [String?]
    let formsSwitchable: Bool
    let genderRate: Int
    let genera: [Genus]
    let generation, growthRate, habitat: Color
    let hasGenderDifferences: Bool
    let hatchCounter, id: Int
    let isBaby, isLegendary, isMythical: Bool
    let name: String
    let names: [Name]
    let order: Int
    let palParkEncounters: [PalParkEncounter]
    let pokedexNumbers: [PokedexNumber]
    let shape: Color
    let varieties: [Variety]
}

// MARK: - Color
struct Color: Codable, Hashable {
    let name: String
    let url: String
}

// MARK: - EvolutionChain
struct EvolutionChain: Codable, Hashable {
    let url: String
}

// MARK: - FlavorTextEntry
struct FlavorTextEntry: Codable, Hashable {
    let flavorText: String
    let language, version: Color
}

// MARK: - Genus
struct Genus: Codable, Hashable {
    let genus: String
    let language: Color
}

// MARK: - Name
struct Name: Codable, Hashable {
    let language: Color
    let name: String
}

// MARK: - PalParkEncounter
struct PalParkEncounter: Codable, Hashable {
    let area: Color
    let baseScore, rate: Int
}

// MARK: - PokedexNumber
struct PokedexNumber: Codable, Hashable {
    let entryNumber: Int
    let pokedex: Color
}

// MARK: - Variety
struct Variety: Codable, Hashable {
    let isDefault: Bool
    let pokemon: Color
}
