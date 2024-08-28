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
class PokemonListViewModelTests: XCTestCase {

    var viewModel: PokemonListViewModel!
    var cancellables: Set<AnyCancellable> = []
    var mockAPIManager: MockAPIManager!

    override func setUpWithError() throws {
        mockAPIManager = MockAPIManager()
        let realmProvider = DefaultRealmProvider()
        let someCacheManager = PokemonCacheManager(realmProvider: realmProvider)
        someCacheManager.clearCache()
        viewModel = PokemonListViewModel(apiManager: mockAPIManager)
    }

    override func tearDownWithError() throws {
        cancellables.forEach { $0.cancel() }
        viewModel = nil
        mockAPIManager = nil
        cancellables.removeAll()
    }

    func testFetchPokemonDetails_ShouldReturnMockedDetails() throws {
        let expectation = XCTestExpectation(description: "Fetch Pokemon Details")
        
        mockAPIManager.mockPokemonDetailsResponse = {
            PokemonDetail(name: "bulbasaur", weight: 69)
        }

        viewModel.fetchPokemonDetails(url: "https://pokeapi.co/api/v2/pokemon/1/")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Error fetching Pokemon details: \(error)")
                }
            }, receiveValue: { pokemonDetails in
                XCTAssertEqual(pokemonDetails.name, "bulbasaur")
                XCTAssertEqual(pokemonDetails.weight, 69)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchPokemonList_ShouldReturnMockedList() throws {
        let expectation = XCTestExpectation(description: "Fetch Pokemon List")
        
        mockAPIManager.mockPokemonListResponse = {
            Pokemon(
                count: 2,
                next: nil,
                previous: nil,
                results: [
                    PokemonListItem(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
                    PokemonListItem(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/")
                ]
            )
        }

        viewModel.$pokemonList
            .dropFirst()  // Ignore initial value
            .sink(receiveValue: { pokemonList in
                XCTAssertFalse(pokemonList.isEmpty, "Pokemon list should not be empty after fetch.")
                XCTAssertEqual(pokemonList.count, 2)
                XCTAssertEqual(pokemonList[0].name, "bulbasaur")
                XCTAssertEqual(pokemonList[1].name, "ivysaur")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.fetchPokemonList()
        
        wait(for: [expectation], timeout: 5.0)
    }
}
