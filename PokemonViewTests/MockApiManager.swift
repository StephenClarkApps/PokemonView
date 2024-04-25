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
class MockAPIManager: APIManagerProtocol {
    
    
    // Could use to simulate error as needed 
    var shouldReturnError = false
    
    func fetchPokemonList(offset: Int, limit: Int) -> AnyPublisher<Pokemon, Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mocked error"]))
                .eraseToAnyPublisher()
        } else {
            let mockPokemon = mockPokemonListResponse()
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
            let mockPokemonDetail = mockPokemonDetailsResponse()
            return Just(mockPokemonDetail)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    
    /// Retrieves a `Pokemon` object from a local JSON file meant to simulate a network response.
    private func mockPokemonListResponse() -> Pokemon {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "MockPokemonList", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pokemon = try? JSONDecoder().decode(Pokemon.self, from: data) else {
            fatalError("Failed to load MockPokemonList.json")
        }
        return pokemon
    }
    
    /// Retrieves a `PokemonDetail` object from a local JSON file to simulate detailed data fetching.
    private func mockPokemonDetailsResponse() -> PokemonDetail {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "MockPokemonDetails", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pokemonDetail = try? JSONDecoder().decode(PokemonDetail.self, from: data) else {
            fatalError("Failed to load MockPokemonDetails.json")
        }
        return pokemonDetail
    }
}