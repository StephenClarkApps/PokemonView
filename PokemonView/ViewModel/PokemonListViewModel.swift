//
//  PokemonListViewModel.swift
//  PokemonView
//
//  Created by Stephen Clark on 22/04/2024.
//

import Combine
import Foundation

class PokemonListViewModel: ObservableObject {
    
    @Published var pokemonList: [IndividualPokemon] = []
    @Published var filteredPokemon: [IndividualPokemon] = []
    @Published var pokemonDetails: PokemonDetail?
    @Published var isLoading: Bool = false
    @Published var currentPage: Int = 0
    @Published var hasMoreData: Bool = true
    @Published var requestSucceeded: Bool = true  // To handle request status
    
    private let apiManager: APIManagerProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func fetchPokemonList() {
        guard !isLoading && hasMoreData else { return }
        isLoading = true

        apiManager.fetchPokemonList(offset: currentPage * 20, limit: 20)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isLoading = false
                case .failure(let error):
                    print("Error fetching Pokémon list: \(error)")
                    self?.isLoading = false
                    self?.hasMoreData = false
                }
            }, receiveValue: { [weak self] response in
                self?.pokemonList.append(contentsOf: response.results)
                self?.filteredPokemon = self?.pokemonList ?? []
                self?.currentPage += 1
                self?.hasMoreData = response.next != nil
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func fetchAndStorePokemonDetails(url: String) {
        fetchPokemonDetails(url: url)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Successfully fetched Pokémon details.")
                case .failure(let error):
                    print("Error fetching Pokémon details: \(error)")
                }
            }, receiveValue: { [weak self] details in
                self?.pokemonDetails = details
                print("Details updated for Pokémon: \(details)")
            })
            .store(in: &cancellables)
    }

    func searchPokemon(name: String) {
        if name.isEmpty {
            filteredPokemon = pokemonList
        } else {
            filteredPokemon = pokemonList.filter { $0.name.lowercased().contains(name.lowercased()) }
        }
    }
    
    func fetchPokemonDetails(url: String) -> AnyPublisher<PokemonDetail, Error> {
        return apiManager.fetchPokemonDetails(url: url)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
