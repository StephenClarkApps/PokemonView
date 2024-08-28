//
//  RealmTests.swift
//  PokemonViewTests
//
//  Created by Stephen Clark on 29/04/2024.
//

import XCTest
import RealmSwift
@testable import PokemonView

class PokemonCacheManagerTests: XCTestCase {
    
    var cacheManager: PokemonCacheManager!
    var realm: Realm!
    
    override func setUp() {
        super.setUp()
        
        // Use an in-memory Realm for testing
        var config = Realm.Configuration(inMemoryIdentifier: self.name)
        // Optionally, set a new schema version to avoid migration issues
        config.schemaVersion = 1
        realm = try! Realm(configuration: config)
        
        let realmProvider = MockRealmProvider(realm: realm)
        cacheManager = PokemonCacheManager(realmProvider: realmProvider)
        cacheManager.clearCache()
    }
    
    override func tearDown() {
        cacheManager.clearCache()
        cacheManager = nil
        realm = nil
        super.tearDown()
    }
    
    func test_SaveAndRetrievePokemonList_WorksCorrectly() {
        // Create a test Pokemon list
        let testPokemon = Pokemon(count: 10, next: "https://test.com", previous: "http://www.google.com", results: [
            IndividualPokemon(name: "Test1", url: "https://test.com/1"),
            IndividualPokemon(name: "Test2", url: "https://test.com/2")
        ])

        // Expectation for the asynchronous saving of the Pokemon list
        let expectation = self.expectation(description: "AsyncSavePokemonList")

        // Save the Pokemon list
        cacheManager.savePokemonList(testPokemon) {
            expectation.fulfill()
        }

        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 5, handler: nil)

        // Retrieve the saved Pokemon list
        let retrievedPokemon = cacheManager.retrievePokemonList()

        // Assert the retrieved data matches the saved data
        XCTAssertEqual(retrievedPokemon?.count, testPokemon.count)
        XCTAssertEqual(retrievedPokemon?.next, testPokemon.next)
        XCTAssertEqual(retrievedPokemon?.previous, testPokemon.previous)
        XCTAssertEqual(retrievedPokemon?.results.count, testPokemon.results.count)
    }
    
    func test_SaveAndRetrievePokemonDetail_WorksCorrectly() {
        // Create a test Pokemon detail
        let testDetail = PokemonDetail(id: 1, name: "Buzz", cries: nil, height: 20, weight: 10, sprites: nil, stats: [], types: [])
        let testUrl = "https://test.com/1"
        
        // Expectation for the asynchronous saving of the Pokemon detail
        let expectation = self.expectation(description: "AsyncSavePokemonDetail")

        // Save the Pokemon detail
        cacheManager.savePokemonDetail(testDetail, for: testUrl) {
            expectation.fulfill()
        }

        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 5, handler: nil)

        // Retrieve the saved Pokemon detail
        let retrievedDetail = cacheManager.retrievePokemonDetail(for: testUrl)
        
        // Assert the retrieved data matches the saved data
        XCTAssertEqual(retrievedDetail?.name, testDetail.name)
        XCTAssertEqual(retrievedDetail?.height, testDetail.height)
        XCTAssertEqual(retrievedDetail?.weight, testDetail.weight)
    }

    func test_ConvertingRealmObjectToCodableStruct_Works() {
        // Create a test Realm Pokemon list
        let realmObject = PokemonRealmObject()
        realmObject.count = 10
        realmObject.next = "https://test.com"
        realmObject.previous = "https://www.something.net"
        
        // Create IndividualPokemonRealmObject instances
        let individualPokemon1 = IndividualPokemonRealmObject()
        individualPokemon1.name = "Test1"
        individualPokemon1.url = "https://test.com/1"
        individualPokemon1.sprite = "https://test.com/123"
        
        let individualPokemon2 = IndividualPokemonRealmObject()
        individualPokemon2.name = "Test2"
        individualPokemon2.url = "https://test.com/2"
        individualPokemon2.sprite = "https://test.com/123"
        
        // Append IndividualPokemonRealmObject instances to results
        realmObject.results.append(individualPokemon1)
        realmObject.results.append(individualPokemon2)

        // Write the Realm object
        try! realm.write {
            realm.deleteAll()
            realm.add(realmObject)
        }
        
        // Retrieve the saved Pokemon list
        let convertedPokemon: Pokemon? = cacheManager.retrievePokemonList()
        
        // Assert the converted data matches the saved data
        XCTAssertEqual(convertedPokemon?.count, realmObject.count)
        XCTAssertEqual(convertedPokemon?.next, realmObject.next)
        XCTAssertEqual(convertedPokemon?.previous, realmObject.previous)
        XCTAssertEqual(convertedPokemon?.results.count, realmObject.results.count)
        XCTAssertEqual(convertedPokemon?.results[0].name, individualPokemon1.name)
        XCTAssertEqual(convertedPokemon?.results[0].url, individualPokemon1.url)
        XCTAssertEqual(convertedPokemon?.results[1].name, individualPokemon2.name)
        XCTAssertEqual(convertedPokemon?.results[1].url, individualPokemon2.url)
    }
    
    func test_ExtractIDFromURL_WorksCorrectly() {
        let testUrl = "https://pokeapi.co/api/v2/pokemon/1/"
        let id = extractIDFromURL(testUrl)
        
        XCTAssertEqual(id, 1)
    }
}
