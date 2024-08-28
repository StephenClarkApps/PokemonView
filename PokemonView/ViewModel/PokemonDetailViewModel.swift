//
//  PokemonDetailViewModel.swift
//  PokemonView
//
//  Created by Stephen Clark on 24/04/2024.
//

import Combine
import Foundation

class PokemonDetailViewModel: ObservableObject {
    @Published var pokemonDetail: PokemonDetail?
    @Published var errorMessage: String?  

    private var cancellables = Set<AnyCancellable>()
    private let apiManager: PokemonAPIManagerProtocol
    
    init(apiManager: PokemonAPIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func loadPokemonDetails(from url: String) {
        apiManager.fetchPokemonDetails(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    // Optionally handle completed state
                    break
                case .failure(let error):
                    Log.shared.debug("Error loading Pokémon details: \(error)")
                    self?.errorMessage = "Failed to load Pokémon details: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] details in
                self?.pokemonDetail = details
            })
            .store(in: &cancellables)
    }
}

