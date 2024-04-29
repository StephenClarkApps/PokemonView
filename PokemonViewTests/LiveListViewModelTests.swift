//
//  LivePokemonListViewModelTests.swift
//  PokemonViewTests
//
//  Created by Stephen Clark on 23/04/2024.
//

import XCTest
import Combine
@testable import PokemonView

@MainActor 
class LiveListViewModelTests: XCTestCase {

    var viewModel: PokemonListViewModel!
    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        let realmProvider = DefaultRealmProvider()
        let someCacheManager = PokemonCacheManager(realmProvider: realmProvider)
        viewModel = PokemonListViewModel(apiManager: APIManager(cacheManager: someCacheManager))
    }

    override func tearDownWithError() throws {
        cancellables.forEach { $0.cancel() }
    }

    func testLiveFetchPokemonDetails_ShouldGivePokemonDetails() throws {
        let expectation = XCTestExpectation(description: "Fetch Live Pokemon Details")
        
        viewModel.fetchPokemonDetails(url: "https://pokeapi.co/api/v2/pokemon/1/")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Success")
                case .failure(let error):
                    XCTFail("Error fetching Pokemon details: \(error)")
                }
            }, receiveValue: { pokemonDetails in
                XCTAssertEqual(pokemonDetails.name, "bulbasaur")
                XCTAssertEqual(pokemonDetails.weight, 69)
                expectation.fulfill()  // Fulfill expectation when receiveValue is called
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }


    func testLiveFetchPokemonList_ShouldFetchList() throws {
        let expectation = XCTestExpectation(description: "Fetch Live Pokemon List")
        
        viewModel.$pokemonList
            .dropFirst()  // Ignore initial value
            .sink(receiveValue: { pokemonList in
                XCTAssertFalse(pokemonList.isEmpty, "Pokemon list should not be empty after fetch.")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.fetchPokemonList()
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Pokemon Species Sync
//    func test_LiveFetchPokemonSpecies_RetrievesSpecies() throws {
//         let expectation = XCTestExpectation(description: "Fetch Live Pokemon Species")
//         let speciesId = 132  // Example species ID for Ditto
//
//         apiManager.fetchPokemonSpecies(speciesId: speciesId)
//             .sink(receiveCompletion: { completion in
//                 if case .failure(let error) = completion {
//                     XCTFail("Failed with error: \(error)")
//                     expectation.fulfill()
//                 }
//             }, receiveValue: { species in
//                 XCTAssertNotNil(species, "The fetched Pokemon species should not be nil")
//                 XCTAssertEqual(species.id, speciesId, "The fetched species ID should match the requested ID")
//                 expectation.fulfill()
//             })
//             .store(in: &cancellables)
//
//         wait(for: [expectation], timeout: 10.0)  // Timeout adjusted based on expected response times
//     }

    // MARK: - SYNC (We probaly want to sync pokemon and species on app launch and store them)
    
    
    // MARK: - Locally Store and Cache Data (SwiftDate or Realm)
    
    // We need data from more than one endpoint in many cases to make up complete
    // data for both our list and details view.
    
    // Because the data is largely immutable which we know is true because it's actually served as static
    // content in the current backend implmentation, we can resonably sync and cache it for a while
    // this also helps us compose each view when we come to it.
    
    // We can have a forceFetch BOOL flag to force the fetching of new results and the clearing of local storage
    // and potentially refresh the data if it's been stored for a while (say over a day for example)
}
