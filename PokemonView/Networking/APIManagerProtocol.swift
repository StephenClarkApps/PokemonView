//
//  APIManagerProtocol.swift
//  PokemonView
//
//  Created by Stephen Clark on 22/04/2024.
//

import Combine

protocol APIManagerProtocol {
    func fetchPokemonList() -> AnyPublisher<[Pokemon], Error>
    func fetchPokemonDetails(name: String) -> AnyPublisher<PokemonDetail, Error>
}
