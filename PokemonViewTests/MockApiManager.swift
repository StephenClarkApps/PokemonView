//
//  MockApiManager.swift
//  PokemonViewTests
//
//  Created by Stephen Clark on 22/04/2024.
//

import Combine
import Foundation
@testable import PokemonView

/// A mock API manager for testing that conforms to the APIManagerProtocol.
/// This class is used to simulate network responses for the purposes of unit testing.
class MockAPIManager: PokemonAPIManagerProtocol {
    
    var shouldReturnError = false
    
    var mockPokemonListResponse: (() -> Pokemon)?
    var mockPokemonDetailsResponse: (() -> PokemonDetail)?
    var mockPokemonSpeciesResponse: (() -> PokemonSpecies)?
    
    func fetchPokemonList(offset: Int, limit: Int) -> AnyPublisher<Pokemon, Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mocked error"]))
                .eraseToAnyPublisher()
        } else {
            let mockPokemon = mockPokemonListResponse?() ?? Pokemon(count: 0, next: nil, previous: nil, results: [])
            return Just(mockPokemon)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchPokemonDetails(url: String) -> AnyPublisher<PokemonDetail, Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mocked error"]))
                .eraseToAnyPublisher()
        } else {
            let mockPokemonDetail = mockPokemonDetailsResponse?() ?? PokemonDetail(name: "", weight: 0)
            return Just(mockPokemonDetail)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchPokemonSpecies(url: String) -> AnyPublisher<PokemonSpecies, Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mocked error"]))
                .eraseToAnyPublisher()
        } else {
            let mockPokemonSpecies = mockPokemonSpeciesResponse?() ?? PokemonSpecies(baseHappiness: 0, captureRate: 0, color: PokemonColor(name: ""), flavorTextEntries: [])
            return Just(mockPokemonSpecies)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
