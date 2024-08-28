//
//  MockRealmProvider.swift
//  PokemonViewTests
//
//  Created by Stephen Clark on 13/06/2024.
//

import Foundation
import RealmSwift
@testable import PokemonView

class MockRealmProvider: RealmProviderProtocol {
    let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
}
