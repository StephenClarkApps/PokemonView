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
    private var cancellables = Set<AnyCancellable>()
    private let apiManager: PokemonAPIManagerProtocol
    
    init(apiManager: PokemonAPIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func loadPokemonDetails(from url: String) {
        apiManager.fetchPokemonDetails(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error loading Pokémon details: \(error)")
                }
            }, receiveValue: { [weak self] details in
                self?.pokemonDetail = details
            })
            .store(in: &cancellables)
    }
}
