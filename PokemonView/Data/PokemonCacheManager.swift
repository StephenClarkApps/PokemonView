//
//  PokemonCacheManager.swift
//  PokemonView
//
//  Created by Stephen Clark on 29/04/2024.
//

import Foundation
import RealmSwift

protocol RealmProvider {
    var realm: Realm { get }
}

class DefaultRealmProvider: RealmProvider {
    var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
}

class PokemonCacheManager: PokemonCacheManagerProtocol {
    
    private let realmProvider: RealmProvider
        
        init(realmProvider: RealmProvider) {
            self.realmProvider = realmProvider
        }
    
    func retrievePokemonList() -> Pokemon? {
        guard let cachedPokemonObject = realmProvider.realm.objects(PokemonRealmObject.self).first else {
            return nil
        }
        let pokemon = Pokemon(from: cachedPokemonObject)
        print("Retrieved Pokemon List from Realm!!!") //: \(pokemon)")
        return pokemon
    }
    
    func retrievePokemonDetail(for url: String) -> PokemonDetail? {
        
        guard let id = extractIDFromURL(url),
              let cachedPokemonDetailObject = realmProvider.realm.objects(PokemonDetailRealmObject.self).filter("id == %@", id).first else {
            return nil
        }
        let pokemonDetail = PokemonDetail(from: cachedPokemonDetailObject)
        print("Retrieved \(pokemonDetail.name) Details from Realm")
        return pokemonDetail
        
    }

    func retrieveLastCacheDate() -> Date? {
        let cacheDate = realmProvider.realm.objects(PokemonRealmObject.self).first?.metadata?.createdAt
        print("Retrieved Last Cache Date from Realm") //: \(cacheDate)")
        return cacheDate
    }

    func savePokemonList(_ pokemonList: Pokemon, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let cachedPokemonObject = PokemonRealmObject(from: pokemonList)
            do {
                let realm = self.realmProvider.realm // Access realm directly from realmProvider
                try realm.write {
                    // Clear the previous data
                    print("realm.deleteAll() called  -  from line 67 PokemonCacheManger")
                    realm.deleteAll()
                    // Add or update the new data
                    realm.add(cachedPokemonObject, update: .modified)
                    completion()  // Call completion after the realm write transaction is complete
                }
            } catch {
                print("Failed to save Pokemon list to Realm: \(error)")
                completion()  // Ensure to call completion even if there is an error
            }
        }
    }


    func savePokemonDetail(_ pokemonDetail: PokemonDetail, for url: String) {
        DispatchQueue.main.async {
            let cachedPokemonDetailObject = PokemonDetailRealmObject(from: pokemonDetail)
            print("Saving \(cachedPokemonDetailObject.name)'s Details to Realm")
            do {
                let realm = self.realmProvider.realm // Access realm directly from realmProvider
                try realm.write {
                    realm.add(cachedPokemonDetailObject, update: .modified)
                }
            } catch {
                print("Failed to save Pokemon detail to Realm: \(error)")
            }
        }
    }


    func clearCache() {
        DispatchQueue.main.async {
            do {
                let realm = self.realmProvider.realm
                try realm.write {
                    print("realm.deleteAll() called  -  from line 102 PokemonCacheManger")
                    realm.deleteAll()
                }
            } catch {
                print("Failed to clear cache: \(error)")
            }
        }
    }

    func refreshData() {
        cacheManager.clearCache()
        retrievePokemonList()
    }

}


// MARK: - PokemonCacheManagerProtocol
protocol PokemonCacheManagerProtocol {
    func retrievePokemonList() -> Pokemon?
    func retrievePokemonDetail(for url: String) -> PokemonDetail?
    func retrieveLastCacheDate() -> Date?
    func savePokemonList(_ pokemonList: Pokemon, completion: @escaping () -> Void)
    func savePokemonDetail(_ pokemonDetail: PokemonDetail, for url: String)
}

func extractIDFromURL(_ url: String) -> Int? {
    let components = url.trimmingCharacters(in: CharacterSet(charactersIn: "/")).split(separator: "/")
    if let idString = components.last, let id = Int(idString) {
        return id
    }
    return nil
}
