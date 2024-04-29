//
//  PokemonViewApp.swift
//  PokemonView
//
//  Created by Stephen Clark on 22/04/2024.
//

import SwiftUI
import RealmSwift

@main
struct PokemonViewApp: SwiftUI.App {
    init() {
        configureRealm()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    private func configureRealm() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { _, _ in
                // Temporarliy just wipe Realm on configuration change for this example app
            },
            deleteRealmIfMigrationNeeded: true
        )
        
        Realm.Configuration.defaultConfiguration = config

        // Realm is initialized
        do {
            _ = try Realm()
        } catch let error as NSError {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
}
