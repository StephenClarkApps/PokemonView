//
//  APIManager.swift
//  PokemonView
//
//  Created by Stephen Clark on 23/04/2024.
//

/// Class that Manages the apps interaction with the backend API service
import Combine
import Foundation

/// Class that Manages the apps interaction with the backend API service
class APIManager: PokemonAPIManagerProtocol {
    
//    func fetchPokemonSpecies(url: String) -> AnyPublisher<PokemonSpecies, any Error> {
//        // NADA
//    }
//    
    private let cacheManager: PokemonCacheManagerProtocol
    
    init(cacheManager: PokemonCacheManagerProtocol) {
        self.cacheManager = cacheManager
    }
    
    func fetchPokemonList(offset: Int = 0, limit: Int = 20) -> AnyPublisher<Pokemon, Error> {
        if let cachedPokemonList = cacheManager.retrievePokemonList(), !isCacheExpired() {
            return Just(cachedPokemonList)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        let url = URL(string: "\(Constants.API.baseURL)\(Constants.API.Endpoints.pokemonList)?offset=\(offset)&limit=\(limit)")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Pokemon.self, decoder: JSONDecoder())
            .map { [weak self] pokemonList in
                self?.cacheManager.savePokemonList(pokemonList)
                return pokemonList
            }
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonDetails(url: String) -> AnyPublisher<PokemonDetail, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        if let cachedPokemonDetail = cacheManager.retrievePokemonDetail(for: url.absoluteString), !isCacheExpired() {
            return Just(cachedPokemonDetail)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonDetail.self, decoder: JSONDecoder())
            .map { [weak self] pokemonDetail in
                self?.cacheManager.savePokemonDetail(pokemonDetail, for: url.absoluteString)
                return pokemonDetail
            }
            .eraseToAnyPublisher()
    }
    
    // Add other methods as needed
    
    func isCacheExpired() -> Bool {
        guard let lastCacheDate = cacheManager.retrieveLastCacheDate() else {
            return true // Cache doesn't exist, need to fetch from API
        }
        let currentDate = Date()
        let timeInterval = currentDate.timeIntervalSince(lastCacheDate)
        return timeInterval > 24 * 60 * 60 // 24 hours in seconds
    }
}
