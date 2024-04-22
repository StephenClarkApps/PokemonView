//
//  PokemonListViewModel.swift
//  PokemonView
//
//  Created by Stephen Clark on 22/04/2024.
//

import Combine
import Foundation

class PokemonListViewModel: ObservableObject {
    
    @Published var pokemonList: [Pokemon] = []
    @Published var filteredPokemon: [Pokemon] = []
    @Published var pokemonDetails: PokemonDetail?
    
    private let apiManager: APIManagerProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func fetchPokemonList() {
        apiManager.fetchPokemonList()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to fetch pokemon list: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] pokemonList in
                DispatchQueue.main.async {
                    self?.pokemonList = pokemonList
                    self?.filteredPokemon = pokemonList
                }
            })
            .store(in: &cancellables)
    }
    
    func searchPokemon(name: String) {
        filteredPokemon = pokemonList.filter { $0.name.lowercased().contains(name.lowercased()) }
    }
    
    func fetchPokemonDetails(name: String) {
        apiManager.fetchPokemonDetails(name: name)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to fetch pokemon details: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] pokemonDetail in
                DispatchQueue.main.async {
                    self?.pokemonDetails = pokemonDetail
                }
            })
            .store(in: &cancellables)
    }
}
