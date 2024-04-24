//
//  LivePokemonListViewModelTests.swift
//  PokemonViewTests
//
//  Created by Stephen Clark on 23/04/2024.
//

import XCTest
import Combine
@testable import PokemonView

@testable import PokemonView

class LiveListViewModelTests: XCTestCase {

    var viewModel: PokemonListViewModel!
    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        viewModel = PokemonListViewModel(apiManager: APIManager())
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

}
