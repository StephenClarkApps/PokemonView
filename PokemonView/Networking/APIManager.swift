//
//  APIManager.swift
//  PokemonView
//
//  Created by Stephen Clark on 23/04/2024.
//

import Combine
import Foundation

/// Class that Manages the app's interaction with the backend API service
class APIManager: PokemonAPIManagerProtocol {
    
    private let cacheManager: PokemonCacheManagerProtocol
    
    init(cacheManager: PokemonCacheManagerProtocol) {
        self.cacheManager = cacheManager
    }
    
    // Generic method to fetch data and cache it if necessary
    private func fetchData<T: Decodable>(from url: URL, cacheKey: String, cacheRetrieval: @escaping () -> T?, cacheSave: @escaping (T) -> Void) -> AnyPublisher<T, Error> {
        if let cachedData = cacheRetrieval() {
            Log.shared.info("Fetching \(T.self) from cache for URL: \(url.absoluteString)")
            return Just(cachedData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        Log.shared.info("Fetching \(T.self) from network for URL: \(url.absoluteString)")
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { [weak self] data in
                self?.cacheSave(data, with: cacheSave)
                Log.shared.info("Saved \(T.self) to cache for URL: \(url.absoluteString)")
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func fetchPokemonList(offset: Int = 0, limit: Int = 20) -> AnyPublisher<Pokemon, Error> {
        let url = URL(string: "\(Constants.API.baseURL)\(Constants.API.Endpoints.pokemonList)?offset=\(offset)&limit=\(limit)")!
        
        return fetchData(from: url, cacheKey: "pokemonList", cacheRetrieval: { [weak self] in
            return self?.cacheManager.retrievePokemonList()
        }, cacheSave: { [weak self] pokemonList in
            self?.cacheManager.savePokemonList(pokemonList) {
                Log.shared.info("The Pokemon List has been saved to Realm")
            }
        })
    }
    
    func fetchPokemonDetails(url: String) -> AnyPublisher<PokemonDetail, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return fetchData(from: url, cacheKey: url.absoluteString, cacheRetrieval: { [weak self] in
            return self?.cacheManager.retrievePokemonDetail(for: url.absoluteString)
        }, cacheSave: { [weak self] pokemonDetail in
            self?.cacheManager.savePokemonDetail(pokemonDetail, for: url.absoluteString) {
                Log.shared.info("Saved Pokemon detail to Realm")
            }
        })
    }

    private func cacheSave<T: Decodable>(_ data: T, with cacheSave: @escaping (T) -> Void) {
        cacheSave(data)
    }
}
