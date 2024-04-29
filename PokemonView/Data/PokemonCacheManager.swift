//
//  PokemonCacheManager.swift
//  PokemonView
//
//  Created by Stephen Clark on 29/04/2024.
//

import Foundation
import RealmSwift

class PokemonCacheManager: PokemonCacheManagerProtocol {
    private var realm: Realm!
    
    init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    func retrievePokemonList() -> Pokemon? {
        guard let cachedPokemonObject = realm.objects(PokemonRealmObject.self).first else {
            return nil
        }
        
        return Pokemon(from: cachedPokemonObject)
    }
    
    func retrievePokemonDetail(for url: String) -> PokemonDetail? {
        guard let id = extractIDFromURL(url),
              let cachedPokemonDetailObject = realm.objects(PokemonDetailRealmObject.self).filter("id == %@", id).first else {
            return nil
        }
        
        return PokemonDetail(from: cachedPokemonDetailObject)
    }

    
    func retrieveLastCacheDate() -> Date? {
        return realm.objects(PokemonRealmObject.self).first?.metadata?.createdAt
    }
    
    func savePokemonList(_ pokemonList: Pokemon) {
        DispatchQueue.main.async {
            let cachedPokemonObject = PokemonRealmObject(from: pokemonList)
            do {
                guard let realm = self.realm else {
                    print("Realm not initialized")
                    return
                }
                try realm.write {
                    // Clear the previous data
                    realm.deleteAll()
                    // Add or update the new data
                    realm.add(cachedPokemonObject, update: .modified)
                }
            } catch {
                print("Failed to save Pokemon list to Realm: \(error)")
            }
        }
    }

    
    func savePokemonDetail(_ pokemonDetail: PokemonDetail, for url: String) {
        DispatchQueue.main.async {
            
            let cachedPokemonDetailObject = PokemonDetailRealmObject(from: pokemonDetail)
            do {
                guard let realm = self.realm else {
                    print("Realm not initialized")
                    return
                }
                try realm.write {
                    realm.add(cachedPokemonDetailObject, update: .modified)
                }
            } catch {
                print("Failed to save Pokemon detail to Realm: \(error)")
            }
        }
    }
}


// MARK: - PokemonCacheManagerProtocol
protocol PokemonCacheManagerProtocol {
    func retrievePokemonList() -> Pokemon?
    func retrievePokemonDetail(for url: String) -> PokemonDetail?
    func retrieveLastCacheDate() -> Date?
    func savePokemonList(_ pokemonList: Pokemon)
    func savePokemonDetail(_ pokemonDetail: PokemonDetail, for url: String)
}

func extractIDFromURL(_ url: String) -> Int? {
    let components = url.trimmingCharacters(in: CharacterSet(charactersIn: "/")).split(separator: "/")
    if let idString = components.last, let id = Int(idString) {
        return id
    }
    return nil
}
