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
    
    override func setUp() {
        super.setUp()
        let realmProvider = DefaultRealmProvider()
        cacheManager = PokemonCacheManager(realmProvider: realmProvider)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSaveAndRetrievePokemonList() {

        // Create a test Pokemon list
        let testPokemon = Pokemon(count: 10, next: "https://test.com", previous: "http://www.google.com", results: [
            IndividualPokemon(name: "Test1", url: "https://test.com/1"),
            IndividualPokemon(name: "Test2", url: "https://test.com/2")
        ])
        cacheManager.savePokemonList(testPokemon)
        
        // Retrieve the saved Pokemon list
        let retrievedPokemon = cacheManager.retrievePokemonList()
        
        print(retrievedPokemon?.results)
        
        XCTAssertEqual(retrievedPokemon?.count, testPokemon.count)
        XCTAssertEqual(retrievedPokemon?.next, testPokemon.next)
        XCTAssertEqual(retrievedPokemon?.previous, testPokemon.previous)
        XCTAssertEqual(retrievedPokemon?.results.count, testPokemon.results.count)
    }

    
    func testSaveAndRetrievePokemonDetail() {

        // Create a test Pokemon detail
        let testDetail = PokemonDetail(id: 1, name: "Buzz", cries: nil, height: 20, weight: 10, sprites: nil, stats: [], types: [])
        let testUrl = "https://test.com"
        cacheManager.savePokemonDetail(testDetail, for: testUrl)
        
        // Retrieve the saved Pokemon detail
        let retrievedDetail = cacheManager.retrievePokemonDetail(for: testUrl)
        
        XCTAssertEqual(retrievedDetail?.name, testDetail.name)
        XCTAssertEqual(retrievedDetail?.height, testDetail.height)
        XCTAssertEqual(retrievedDetail?.weight, testDetail.weight)
    }
    
    func testConvertingCodableToRealm() {
        // Create a test Pokemon list

        let testPokemon = Pokemon(count: 10, next: "https://test.com", previous: "", results: [
            IndividualPokemon(name: "Test1", url: "https://test.com/1"),
            IndividualPokemon(name: "Test2", url: "https://test.com/2")
        ])
        
        // Convert to Realm object and save
        cacheManager.savePokemonList(testPokemon)
        
        // Retrieve the saved Pokemon list
        let retrievedPokemon: Pokemon? = cacheManager.retrievePokemonList()
        
        XCTAssertEqual(retrievedPokemon?.count, testPokemon.count)
        XCTAssertEqual(retrievedPokemon?.next, testPokemon.next)
        XCTAssertEqual(retrievedPokemon?.previous, testPokemon.previous)
        XCTAssertEqual(retrievedPokemon?.results.count, testPokemon.results.count)
    }

    func testConvertingRealmToCodable() {
        // Create a test Realm Pokemon list
        let realmObject = PokemonRealmObject()
        realmObject.count = 10
        realmObject.next = "https://test.com"
        realmObject.previous = "https://www.something.net"
        realmObject.metadata = PokemonListMetadata()
        
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
        try! realmProvider.realm.write {
            realmProvider.realm.add(realmObject)
        }
        
        // Retrieve the saved Pokemon list
        let convertedPokemon: Pokemon? = cacheManager.retrievePokemonList()
        
        XCTAssertEqual(convertedPokemon?.count, realmObject.count)
        XCTAssertEqual(convertedPokemon?.next, realmObject.next)
        XCTAssertEqual(convertedPokemon?.previous, realmObject.previous)
        
        // Check if results are properly populated
        XCTAssertEqual(convertedPokemon?.results.count, realmObject.results.count)
        XCTAssertEqual(convertedPokemon?.results[0].name, individualPokemon1.name)
        XCTAssertEqual(convertedPokemon?.results[0].url, individualPokemon1.url)
        XCTAssertEqual(convertedPokemon?.results[1].name, individualPokemon2.name)
        XCTAssertEqual(convertedPokemon?.results[1].url, individualPokemon2.url)
    }




    
    func testExtractIDFromURL() {
        let testUrl = "https://pokeapi.co/api/v2/pokemon/1/"
        let id = extractIDFromURL(testUrl)
        
        XCTAssertEqual(id, 1)
    }
}
