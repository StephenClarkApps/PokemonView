//
//  APIManager.swift
//  PokemonView
//
//  Created by Stephen Clark on 23/04/2024.
//

/// Class that Manages the apps interaction with the backend API service
import Combine
import Foundation

// TODO: - Optimise, for example with the use of Generics to de-duplicate code

/// Class that Manages the apps interaction with the backend API service
class APIManager: PokemonAPIManagerProtocol {
    
    private let cacheManager: PokemonCacheManagerProtocol
    
    init(cacheManager: PokemonCacheManagerProtocol) {
        self.cacheManager = cacheManager
    }
    
    func fetchPokemonList(offset: Int = 0, limit: Int = 20) -> AnyPublisher<Pokemon, Error> {
        if let cachedPokemonList = cacheManager.retrievePokemonList() { // , !isCacheExpired() {
            return Just(cachedPokemonList)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        let url = URL(string: "\(Constants.API.baseURL)\(Constants.API.Endpoints.pokemonList)?offset=\(offset)&limit=\(limit)")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Pokemon.self, decoder: JSONDecoder())
            .map { [weak self] pokemonList in
                self?.cacheManager.savePokemonList(pokemonList, completion:{
                    print("The Pokemon List Has been Saved to Realm")
                })
                return pokemonList
            }
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonDetails(url: String) -> AnyPublisher<PokemonDetail, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        // Check cache first
        if let cachedDetail = cacheManager.retrievePokemonDetail(for: url.absoluteString) {  //, !isCacheExpired() {
            print("fetching pokemon details from the Realm Cache: \(url.absoluteString)")
            return Just(cachedDetail)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        print("fetching pokemon details from the Network: \(url.absoluteString)")

        // Fetch from network
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonDetail.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { [weak self] pokemonDetail in
                self?.cacheManager.savePokemonDetail(pokemonDetail, for: url.absoluteString, completion: {
                    print("Saved pokemon detail")
                })
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
