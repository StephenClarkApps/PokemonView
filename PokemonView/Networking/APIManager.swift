//
//  APIManager.swift
//  PokemonView
//
//  Created by Stephen Clark on 23/04/2024.
//

import Combine
import Foundation

/// Class that Manages the apps interaction with the backend API service
class APIManager: APIManagerProtocol {
    
    
    // TODO: - Due to the required functionality, we will likely be fetching all the Poké up front
    // and we will probably cache them with something like SwiftData or Realm
    
    
    /// Fetches a list of Pokemon from the API with optional pagination.
    /// - Parameters:
    ///   - offset: The number of items to skip before starting to collect the result set.
    ///   - limit: The maximum number of items to return.
    /// - Returns: A publisher that emits a `Pokemon` object or an error.
    func fetchPokemonList(offset: Int = 0, limit: Int = 20) -> AnyPublisher<Pokemon, Error> {
        let url = URL(string: "\(Constants.API.baseURL)\(Constants.API.Endpoints.pokemonList)?offset=\(offset)&limit=\(limit)")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Pokemon.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// Fetches detailed information about a specific Pokemon from the API.
    /// - Parameter url: The URL to fetch Pokemon details.
    /// - Returns: A publisher that emits `PokemonDetail` object or an error.
    func fetchPokemonDetails(url: String) -> AnyPublisher<PokemonDetail, Error> {
        guard let url = URL(string: url) else {
            fatalError("Invalid URL")
        }
        print("Fetching details from URL: \(url)")
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonDetail.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { response in
                print("Received response: \(response)")
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
