import Testing
import UIKit
@testable import HopSpot

// MARK: - Mocks

class MockBeerDetailViewController: BeerDetailViewController {
    var loadingStates: [Bool] = []
    var updatedBeer: Beer? = nil
    var errorMessage: String? = nil

    override func showLoading(_ loading: Bool) {
        loadingStates.append(loading)
    }
    override func updateDetails(beer: Beer) {
        updatedBeer = beer
    }
    override func showError(_ message: String) {
        errorMessage = message
    }
}

class MockNetworkManager: NetworkManagerProtocol {
    var beerToReturn: Beer? = nil
    var shouldFail = false

    func getBeerList(page: Int, perPage: Int, completion: @escaping ([BeerListItem], Bool) -> ()) {
        completion([], false)
    }
    func getBeerDetails(id: Int, completion: @escaping (Beer?) -> ()) {
        completion(shouldFail ? nil : beerToReturn)
    }
}

// MARK: - Helpers

private func makeBeer(abv: Double? = nil, ibu: Double? = nil, ebc: Double? = nil,
                      foodPairing: [String]? = nil, tips: String? = nil,
                      ingredients: Ingredients? = nil) -> Beer {
    var b = Beer(id: 1, name: "Test Beer", tagline: "Tagline", abv: abv, ibu: ibu, ebc: ebc,
                 food_pairing: foodPairing, brewers_tips: tips, image: nil, ingredients: ingredients, method: nil)
    b.description = nil
    return b
}

// MARK: - Tests

@Suite("BeerDetailController formatting")
struct BeerDetailControllerTests {

    // MARK: getFormattedABV

    @Test("getFormattedABV uses beer abv when available")
    func testABVFromBeer() async throws {
        let mockView = MockBeerDetailViewController(listItem: BeerListItem(name: "X", tagline: "Y"))
        let network = MockNetworkManager()
        network.beerToReturn = makeBeer(abv: 6.5)
        let controller = BeerDetailController(view: mockView, listItem: BeerListItem(name: "X", tagline: "Y"), networkManager: network)

        await withCheckedContinuation { cont in
            controller.loadDetails(id: 1) { cont.resume() }
        }
        #expect(controller.getFormattedABV() == "ABV 6.5%")
    }

    @Test("getFormattedABV falls back to listItem abv")
    func testABVFromListItem() {
        let item = BeerListItem(id: 1, name: "X", tagline: "Y", abv: 4.2)
        let mockView = MockBeerDetailViewController(listItem: item)
        let controller = BeerDetailController(view: mockView, listItem: item, networkManager: MockNetworkManager())
        #expect(controller.getFormattedABV() == "ABV 4.2%")
    }

    @Test("getFormattedABV returns fallback when nil")
    func testABVNil() {
        let item = BeerListItem(name: "X", tagline: "Y")
        let mockView = MockBeerDetailViewController(listItem: item)
        let controller = BeerDetailController(view: mockView, listItem: item, networkManager: MockNetworkManager())
        #expect(controller.getFormattedABV() == "ABV n/a")
    }

    // MARK: getFormattedIBU / EBC

    @Test("getFormattedIBU returns formatted value")
    func testIBU() async throws {
        let mockView = MockBeerDetailViewController(listItem: BeerListItem(name: "X", tagline: "Y"))
        let network = MockNetworkManager()
        network.beerToReturn = makeBeer(ibu: 40)
        let controller = BeerDetailController(view: mockView, listItem: BeerListItem(name: "X", tagline: "Y"), networkManager: network)
        await withCheckedContinuation { cont in controller.loadDetails(id: 1) { cont.resume() } }
        #expect(controller.getFormattedIBU() == "IBU 40")
    }

    @Test("getFormattedIBU returns fallback when nil")
    func testIBUNil() {
        let item = BeerListItem(name: "X", tagline: "Y")
        let controller = BeerDetailController(view: MockBeerDetailViewController(listItem: item), listItem: item, networkManager: MockNetworkManager())
        #expect(controller.getFormattedIBU() == "IBU n/a")
    }

    @Test("getFormattedEBC returns formatted value")
    func testEBC() async throws {
        let mockView = MockBeerDetailViewController(listItem: BeerListItem(name: "X", tagline: "Y"))
        let network = MockNetworkManager()
        network.beerToReturn = makeBeer(ebc: 17)
        let controller = BeerDetailController(view: mockView, listItem: BeerListItem(name: "X", tagline: "Y"), networkManager: network)
        await withCheckedContinuation { cont in controller.loadDetails(id: 1) { cont.resume() } }
        #expect(controller.getFormattedEBC() == "EBC 17")
    }

    // MARK: getFoodPairingText

    @Test("getFoodPairingText joins items with newline")
    func testFoodPairing() async throws {
        let mockView = MockBeerDetailViewController(listItem: BeerListItem(name: "X", tagline: "Y"))
        let network = MockNetworkManager()
        network.beerToReturn = makeBeer(foodPairing: ["Cheese", "Steak"])
        let controller = BeerDetailController(view: mockView, listItem: BeerListItem(name: "X", tagline: "Y"), networkManager: network)
        await withCheckedContinuation { cont in controller.loadDetails(id: 1) { cont.resume() } }
        #expect(controller.getFoodPairingText() == "Cheese\nSteak")
    }

    @Test("getFoodPairingText returns fallback for empty array")
    func testFoodPairingEmpty() async throws {
        let mockView = MockBeerDetailViewController(listItem: BeerListItem(name: "X", tagline: "Y"))
        let network = MockNetworkManager()
        network.beerToReturn = makeBeer(foodPairing: [])
        let controller = BeerDetailController(view: mockView, listItem: BeerListItem(name: "X", tagline: "Y"), networkManager: network)
        await withCheckedContinuation { cont in controller.loadDetails(id: 1) { cont.resume() } }
        #expect(controller.getFoodPairingText() == "No food pairing recommendations")
    }

    // MARK: getBrewersTipsText

    @Test("getBrewersTipsText returns tip when available")
    func testBrewersTips() async throws {
        let mockView = MockBeerDetailViewController(listItem: BeerListItem(name: "X", tagline: "Y"))
        let network = MockNetworkManager()
        network.beerToReturn = makeBeer(tips: "Dry hop for 3 days")
        let controller = BeerDetailController(view: mockView, listItem: BeerListItem(name: "X", tagline: "Y"), networkManager: network)
        await withCheckedContinuation { cont in controller.loadDetails(id: 1) { cont.resume() } }
        #expect(controller.getBrewersTipsText() == "Dry hop for 3 days")
    }

    @Test("getBrewersTipsText returns fallback when nil")
    func testBrewersTipsNil() {
        let item = BeerListItem(name: "X", tagline: "Y")
        let controller = BeerDetailController(view: MockBeerDetailViewController(listItem: item), listItem: item, networkManager: MockNetworkManager())
        #expect(controller.getBrewersTipsText() == "No brewer's tips available")
    }

    // MARK: loadDetails

    @Test("loadDetails calls showError when id is nil")
    func testLoadDetailsNoID() {
        let item = BeerListItem(name: "X", tagline: "Y") // no id
        let mockView = MockBeerDetailViewController(listItem: item)
        let controller = BeerDetailController(view: mockView, listItem: item, networkManager: MockNetworkManager())
        controller.loadDetails()
        #expect(mockView.errorMessage == "Beer ID not available")
    }

    @Test("loadDetails calls showError on network failure")
    func testLoadDetailsNetworkFailure() async throws {
        let item = BeerListItem(id: 1, name: "X", tagline: "Y")
        let mockView = MockBeerDetailViewController(listItem: item)
        let network = MockNetworkManager()
        network.shouldFail = true
        let controller = BeerDetailController(view: mockView, listItem: item, networkManager: network)
        await withCheckedContinuation { cont in controller.loadDetails(id: 1) { cont.resume() } }
        #expect(mockView.errorMessage == "Failed to load beer details")
    }

    @Test("loadDetails calls updateDetails on success")
    func testLoadDetailsSuccess() async throws {
        let item = BeerListItem(id: 1, name: "X", tagline: "Y")
        let mockView = MockBeerDetailViewController(listItem: item)
        let network = MockNetworkManager()
        network.beerToReturn = makeBeer(abv: 5.0)
        let controller = BeerDetailController(view: mockView, listItem: item, networkManager: network)
        await withCheckedContinuation { cont in controller.loadDetails(id: 1) { cont.resume() } }
        #expect(mockView.updatedBeer != nil)
        #expect(mockView.errorMessage == nil)
    }

    // MARK: getIngredientsText

    @Test("getIngredientsText returns fallback when no ingredients")
    func testIngredientsNil() {
        let item = BeerListItem(name: "X", tagline: "Y")
        let controller = BeerDetailController(view: MockBeerDetailViewController(listItem: item), listItem: item, networkManager: MockNetworkManager())
        #expect(controller.getIngredientsText() == "No ingredients information available")
    }

    @Test("getIngredientsText includes malt section")
    func testIngredientsMalt() async throws {
        let malt = [Malt(name: "Pale Ale", amount: Amount(value: 3.5, unit: "kg"))]
        let ingredients = Ingredients(malt: malt, hops: nil, yeast: nil)
        let network = MockNetworkManager()
        network.beerToReturn = makeBeer(ingredients: ingredients)
        let item = BeerListItem(name: "X", tagline: "Y")
        let mockView = MockBeerDetailViewController(listItem: item)
        let controller = BeerDetailController(view: mockView, listItem: item, networkManager: network)
        await withCheckedContinuation { cont in controller.loadDetails(id: 1) { cont.resume() } }
        let text = controller.getIngredientsText()
        #expect(text.contains("Malt:"))
        #expect(text.contains("Pale Ale"))
        #expect(text.contains("3.5"))
        #expect(text.contains("kg"))
    }

    @Test("getIngredientsText includes hops section")
    func testIngredientsHops() async throws {
        let hops = [Hop(name: "Simcoe", amount: Amount(value: 25.0, unit: "g"), add: "start", attribute: "bitter")]
        let ingredients = Ingredients(malt: nil, hops: hops, yeast: nil)
        let network = MockNetworkManager()
        network.beerToReturn = makeBeer(ingredients: ingredients)
        let item = BeerListItem(name: "X", tagline: "Y")
        let mockView = MockBeerDetailViewController(listItem: item)
        let controller = BeerDetailController(view: mockView, listItem: item, networkManager: network)
        await withCheckedContinuation { cont in controller.loadDetails(id: 1) { cont.resume() } }
        let text = controller.getIngredientsText()
        #expect(text.contains("Hops:"))
        #expect(text.contains("Simcoe"))
        #expect(text.contains("start"))
    }

    @Test("getIngredientsText includes yeast")
    func testIngredientsYeast() async throws {
        let ingredients = Ingredients(malt: nil, hops: nil, yeast: "Wyeast 1056")
        let network = MockNetworkManager()
        network.beerToReturn = makeBeer(ingredients: ingredients)
        let item = BeerListItem(name: "X", tagline: "Y")
        let mockView = MockBeerDetailViewController(listItem: item)
        let controller = BeerDetailController(view: mockView, listItem: item, networkManager: network)
        await withCheckedContinuation { cont in controller.loadDetails(id: 1) { cont.resume() } }
        let text = controller.getIngredientsText()
        #expect(text.contains("Yeast: Wyeast 1056"))
    }

    @Test("getIngredientsText returns fallback when all sections empty")
    func testIngredientsAllEmpty() async throws {
        let ingredients = Ingredients(malt: [], hops: [], yeast: nil)
        let network = MockNetworkManager()
        network.beerToReturn = makeBeer(ingredients: ingredients)
        let item = BeerListItem(name: "X", tagline: "Y")
        let mockView = MockBeerDetailViewController(listItem: item)
        let controller = BeerDetailController(view: mockView, listItem: item, networkManager: network)
        await withCheckedContinuation { cont in controller.loadDetails(id: 1) { cont.resume() } }
        #expect(controller.getIngredientsText() == "No ingredients information available")
    }
}
