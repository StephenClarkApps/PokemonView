//
//  MockApiManager.swift
//  PokemonViewTests
//
//  Created by Stephen Clark on 22/04/2024.
//

import Combine
@testable import PokemonView

class MockAPIManager: APIManagerProtocol {

    func fetchPokemonList() -> AnyPublisher<[Pokemon], Error> {
        let pokemonList = [
            Pokemon(name: "bulbasaur", sprites: ["front_default": ""]),
            Pokemon(name: "charmander", sprites: ["front_default": ""]),
            // Add more Pokemon for testing
        ]
        return Just(pokemonList)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func fetchPokemonDetails(name: String) -> AnyPublisher<PokemonDetail, Error> {
        let pokemonDetail = PokemonDetail(stats: [
            Stat(name: "hp", baseStat: 45),
            Stat(name: "attack", baseStat: 49),
            // Add more stats for testing
        ])
        return Just(pokemonDetail)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
