//
//  APIManagerProtocol.swift
//  PokemonView
//
//  Created by Stephen Clark on 22/04/2024.
//

import Combine

// Use a protocol to define what an API manger looks like and the functions it must implement
// (using protocols can help with unit testing by allowing mocking, and also supports a POP approach)

protocol APIManagerProtocol {
    func fetchPokemonList(offset: Int, limit: Int) -> AnyPublisher<Pokemon, Error>
    func fetchPokemonDetails(url: String) -> AnyPublisher<PokemonDetail, Error>
    
}
