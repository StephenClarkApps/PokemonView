//
//  PokemonListViewModel.swift
//  PokemonView
//
//  Created by Stephen Clark on 22/04/2024.
//

import Combine
import Foundation
import RealmSwift

// MARK: - PokemonDataStore Protocol and Implementation
protocol PokemonDataStoreProtocol {
    func savePokemonList(_ pokemonList: [IndividualPokemon])
    func fetchPokemonList() -> [IndividualPokemon]
    func clearAllData()
}

final class PokemonDataStore: PokemonDataStoreProtocol {
    private let realm: Realm
    
    init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Error initializing Realm: \(error)")
        }
    }

    func savePokemonList(_ pokemonList: [IndividualPokemon]) {
        do {
            try realm.write {
                realm.deleteAll()
                let realmObjects = pokemonList.map { IndividualPokemonRealmObject(from: $0) }
                realm.add(realmObjects)
            }
        } catch {
            Log.shared.error("Error saving to Realm: \(error)")
        }
    }
    
    func fetchPokemonList() -> [IndividualPokemon] {
        return Array(realm.objects(IndividualPokemonRealmObject.self)).map { $0.toIndividualPokemon() }
    }
    
    func clearAllData() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            Log.shared.error("Error clearing Realm data: \(error)")
        }
    }
}

// MARK: - PokemonListViewModel Implementation
@MainActor
final class PokemonListViewModel: ObservableObject {
    
    @Published private(set) var pokemonList: [IndividualPokemon] = []
    @Published private(set) var filteredPokemon: [IndividualPokemon] = []
    @Published var pokemonDetails: PokemonDetail?
    @Published var isLoading: Bool = false
    @Published var hasMoreData: Bool = true
    @Published var requestSucceeded: Bool = true
    @Published var searchQuery: String = ""

    private let apiManager: PokemonAPIManagerProtocol
    private let dataStore: PokemonDataStoreProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(apiManager: PokemonAPIManagerProtocol, dataStore: PokemonDataStoreProtocol) {
        self.apiManager = apiManager
        self.dataStore = dataStore
        self.loadCachedPokemonList()
        self.setupSearchPipeline()
    }

    private func setupSearchPipeline() {
        $searchQuery
            .debounce(for: .milliseconds(350), scheduler: RunLoop.main)
            .removeDuplicates()
            .combineLatest($pokemonList)
            .map { query, list in
                Log.shared.debug("Debounced search executed with query: \(query)")
                return query.isEmpty ? list : list.filter { $0.name.lowercased().contains(query.lowercased()) }
            }
            .assign(to: &$filteredPokemon)
    }

    private func loadCachedPokemonList() {
        pokemonList = dataStore.fetchPokemonList()
        filteredPokemon = pokemonList
        hasMoreData = pokemonList.isEmpty
    }

    func fetchPokemonList() {
        guard !isLoading, hasMoreData else { return }
        isLoading = true
        let limit = 2000

        apiManager.fetchPokemonList(offset: 0, limit: limit)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    Log.shared.error("Error fetching Pokémon list: \(error)")
                    self.requestSucceeded = false
                case .finished:
                    self.requestSucceeded = true
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.pokemonList = response.results
                self.filteredPokemon = response.results
                self.dataStore.savePokemonList(response.results)
                self.hasMoreData = false
            })
            .store(in: &cancellables)
    }

    func fetchAndStorePokemonDetails(url: String) {
        fetchPokemonDetails(url: url)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    Log.shared.error("Error fetching Pokémon details: \(error)")
                }
            }, receiveValue: { [weak self] details in
                self?.pokemonDetails = details
                Log.shared.info("Details updated for Pokémon: \(details)")
            })
            .store(in: &cancellables)
    }

    func searchPokemon(name: String) {
        Log.shared.debug("Search query updated: \(name)")
        searchQuery = name
    }

    func fetchPokemonDetails(url: String) -> AnyPublisher<PokemonDetail, Error> {
        return apiManager.fetchPokemonDetails(url: url)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func clearCacheAndFetchPokemonList() {
        // Clear cache
        dataStore.clearAllData()

        // Fetch fresh data
        fetchPokemonList()
    }
}
