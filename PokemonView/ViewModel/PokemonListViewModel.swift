//
//  PokemonListViewModel.swift
//  PokemonView
//
//  Created by Stephen Clark on 22/04/2024.
//

import Combine
import Foundation
import RealmSwift

@MainActor
class PokemonListViewModel: ObservableObject {
    
    @Published var pokemonList: [IndividualPokemon] = []
    @Published var filteredPokemon: [IndividualPokemon] = []
    @Published var pokemonDetails: PokemonDetail?
    @Published var pokemonSpecies: PokemonSpecies?
    @Published var isLoading: Bool = false
    @Published var currentPage: Int = 0
    @Published var hasMoreData: Bool = true
    @Published var requestSucceeded: Bool = true  // To handle request status
    
    private let apiManager: PokemonAPIManagerProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    private var realm: Realm?

    init(apiManager: PokemonAPIManagerProtocol) {
        self.apiManager = apiManager
        do {
            self.realm = try Realm()
        } catch {
            print("Error initializing Realm: \(error)")
        }
    }

//    func fetchPokemonDetailsIfNeeded(for pokemon: IndividualPokemon) {
//        guard pokemon.spriteUrl == nil || pokemon.spriteUrl.isEmpty, !isLoading else { return }
//        isLoading = true
//
//        apiManager.fetchPokemonDetails(url: pokemon.url)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] completion in
//                self?.isLoading = false
//                if case .failure(let error) = completion {
//                    print("Error fetching Pokémon details: \(error)")
//                }
//            }, receiveValue: { [weak self] detail in
//                if let spriteUrl = detail.sprites?.frontDefault {
//                    self?.updatePokemonSprite(for: pokemon.id, with: spriteUrl)
//                }
//            })
//            .store(in: &cancellables)
//    }
//    
//
//    private func updatePokemonSprite(for id: String, with spriteUrl: String?) {
//        guard let index = pokemonList.firstIndex(where: { $0.id == id }) else { return }
//        pokemonList[index].spriteUrl = spriteUrl
//    }

    
    func fetchPokemonList() {
        guard !isLoading else { return }
        isLoading = true
        let limit = 2000  // Fetch all Pokémon, adjust if the number increases in the future.

        apiManager.fetchPokemonList(offset: 0, limit: limit)
            .sink(receiveCompletion: { [weak self] completion in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        print("Error fetching Pokémon list: \(error)")
                        self?.requestSucceeded = false
                    }
                }
            }, receiveValue: { [weak self] response in
                DispatchQueue.main.async {
                    // Perform Realm operations here directly on the main thread
                    self?.updateRealm(with: response.results)
                    self?.hasMoreData = false  // No more data to fetch as we've got all Pokémon.
                }
            })
            .store(in: &cancellables)
    }

    func updateRealm(with results: [IndividualPokemon]) {
        guard let realm = self.realm else {
            print("Realm not initialized")
            return
        }
        do {
            try realm.write {
                realm.deleteAll()
                let realmObjects = results.map { IndividualPokemonRealmObject(from: $0) }
                realm.add(realmObjects)
                DispatchQueue.main.async {
                    self.pokemonList = results
                    self.filteredPokemon = results
                }
            }
        } catch {
            print("Error updating Realm: \(error)")
        }
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
    
    func clearCacheAndFetchPokemonList() {
        // Clear here
        filteredPokemon = []
        pokemonList = []
        pokemonDetails = nil
        pokemonSpecies = nil
        
        // Clear cache
        cacheManager.clearCache()

        // Fetch fresh data
        fetchPokemonList()
    }
    
}
