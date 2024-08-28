//
//  PokemonCacheManager.swift
//  PokemonView
//
//  Created by Stephen Clark on 29/04/2024.
//
import Foundation
import RealmSwift

// MARK: - RealmProvider Protocol and Implementation
protocol RealmProviderProtocol {
    var realm: Realm { get }
}

class DefaultRealmProvider: RealmProviderProtocol {
    var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
}

// MARK: - PokemonCacheManager Protocol
protocol PokemonCacheManagerProtocol {
    func retrievePokemonList() -> Pokemon?
    func retrievePokemonDetail(for url: String) -> PokemonDetail?
    func retrieveLastCacheDate() -> Date?
    func savePokemonList(_ pokemonList: Pokemon, completion: @escaping () -> Void)
    func savePokemonDetail(_ pokemonDetail: PokemonDetail, for url: String, completion: @escaping () -> Void)
    func clearCache()
    func refreshData()
}

// MARK: - PokemonCacheManager Implementation
class PokemonCacheManager: PokemonCacheManagerProtocol {

    private let realmProvider: RealmProviderProtocol
    
    init(realmProvider: RealmProviderProtocol) {
        self.realmProvider = realmProvider
    }
    
    func retrievePokemonList() -> Pokemon? {
        guard let cachedPokemonObject = realmProvider.realm.objects(PokemonRealmObject.self).first else {
            return nil
        }
        let pokemon = Pokemon(from: cachedPokemonObject)
        Log.shared.info("Retrieved Pokemon List from Realm")
        return pokemon
    }
    
    func retrievePokemonDetail(for url: String) -> PokemonDetail? {
        guard let id = extractIDFromURL(url),
              let cachedPokemonDetailObject = realmProvider.realm.objects(PokemonDetailRealmObject.self).filter("id == %@", id).first else {
            return nil
        }
        let pokemonDetail = PokemonDetail(from: cachedPokemonDetailObject)
        Log.shared.info("Retrieved \(pokemonDetail.name) Details from Realm")
        return pokemonDetail
    }

    func retrieveLastCacheDate() -> Date? {
        let cacheDate = realmProvider.realm.objects(PokemonRealmObject.self).first?.metadata?.createdAt
        Log.shared.debug("Retrieved Last Cache Date from Realm")
        return cacheDate
    }

    func savePokemonList(_ pokemonList: Pokemon, completion: @escaping () -> Void) {
        performWrite { realm in
            let cachedPokemonObject = PokemonRealmObject(from: pokemonList)
            Log.shared.debug("Saving Pokemon list to Realm")
            realm.deleteAll()  // Clear previous data
            realm.add(cachedPokemonObject, update: .modified)
            completion()
        }
    }

    func savePokemonDetail(_ pokemonDetail: PokemonDetail, for url: String, completion: @escaping () -> Void) {
        performWrite { realm in
            let cachedPokemonDetailObject = PokemonDetailRealmObject(from: pokemonDetail)
            Log.shared.debug("Saving \(cachedPokemonDetailObject.name)'s Details to Realm")
            realm.add(cachedPokemonDetailObject, update: .modified)
            completion()
        }
    }

    func clearCache() {
        performWrite { realm in
            Log.shared.debug("Clearing all data in Realm")
            realm.deleteAll()
        }
    }

    func refreshData() {
        clearCache()
        _ = retrievePokemonList()  // This line doesn't seem to achieve anything as it's not used elsewhere. Consider removing it if unnecessary.
    }

    // MARK: - Private Helper Method for Realm Write Operations
    private func performWrite(_ block: @escaping (Realm) -> Void) {
        DispatchQueue.main.async {
            do {
                let realm = self.realmProvider.realm
                try realm.write {
                    block(realm)
                }
            } catch {
                Log.shared.error("Realm write transaction failed: \(error)")
            }
        }
    }
}

// MARK: - Utility Function
func extractIDFromURL(_ url: String) -> Int? {
    let components = url.trimmingCharacters(in: CharacterSet(charactersIn: "/")).split(separator: "/")
    return Int(components.last ?? "")
}
