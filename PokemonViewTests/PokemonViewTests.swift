//
//  PokemonViewTests.swift
//  PokemonViewTests
//
//  Created by Stephen Clark on 22/04/2024.
//

import XCTest
import Combine
@testable import PokemonView

class PokemonListViewModelTests: XCTestCase {

    var viewModel: PokemonListViewModel!
    var mockAPIManager: MockAPIManager!

    override func setUp() {
        super.setUp()
        mockAPIManager = MockAPIManager()
        viewModel = PokemonListViewModel(apiManager: mockAPIManager)
    }

    func testFetchPokemonList_ShouldFetchList() {
        // GIVEN
        let expectation = XCTestExpectation(description: "Fetch Pokemon List")

        // WHEN
        viewModel.fetchPokemonList()

        // THEN
        var receivedPokemonList: [Pokemon]?
        var receivedError: Error?

        let cancellable = viewModel.$pokemonList
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    receivedError = error
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { pokemonList in
                receivedPokemonList = pokemonList
            })

        wait(for: [expectation], timeout: 2.0)

        XCTAssertNotNil(receivedPokemonList)
        XCTAssertNil(receivedError)
        XCTAssertEqual(receivedPokemonList?.count, 2) // We'll ajust this to match the number of pokés that get fetched usually
        cancellable.cancel()
    }
    
    func testSearchPokemon_ShouldFilterList() {
        // GIVEN
        let expectation = XCTestExpectation(description: "Pokemon List Correctly Filtered")

        // WHEN
        viewModel.fetchPokemonList()
        viewModel.searchPokemon(name: "bulbasaur")

        // THEN
        var receivedFilteredPokemon: [Pokemon]?
        var receivedError: Error?

        let cancellable = viewModel.$filteredPokemon
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    receivedError = error
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { filteredPokemon in
                receivedFilteredPokemon = filteredPokemon
            })

        wait(for: [expectation], timeout: 2.0)

        XCTAssertNotNil(receivedFilteredPokemon)
        XCTAssertNil(receivedError)
        XCTAssertEqual(receivedFilteredPokemon?.count, 1) // Assuming only 1 Pokemon matches the search criteria
        cancellable.cancel()
    }
    
    func testFetchPokemonDetails_ShouldGivePokemonDetails() {
        // GIVEN
        let expectation = XCTestExpectation(description: "Fetch Pokemon Details")

        // WHEN
        viewModel.fetchPokemonDetails(name: "bulbasaur")

        // THEN
        var receivedPokemonDetails: PokemonDetail?
        var receivedError: Error?

        let cancellable = viewModel.$pokemonDetails
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    receivedError = error
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { pokemonDetails in
                receivedPokemonDetails = pokemonDetails
            })

        wait(for: [expectation], timeout: 2.0)

        XCTAssertNotNil(receivedPokemonDetails)
        XCTAssertNil(receivedError)
        
        // TODO: - Assetions for the received Pokés deets (make sure params equal what we expect)
        cancellable.cancel()
    }
}
