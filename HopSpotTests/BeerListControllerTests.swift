import Testing
import UIKit
@testable import HopSpot

// Mock for BeerListViewController to avoid using real UI
class MockBeerListViewController: BeerListViewController {
    var didReloadTableData = false
    var didSetCacheCount = false
    var lastFavouritesActive: Bool? = nil
    var lastLoadingState: Bool? = nil

    override func reloadTableData() {
        didReloadTableData = true
    }
    override func setCacheCount(_ count: Int) {
        didSetCacheCount = true
    }
    override func updateFavouritesButton(active: Bool) {
        lastFavouritesActive = active
    }
    override func setLoading(_ loading: Bool) {
        lastLoadingState = loading
    }
}

// Mock database — no Realm, no threads
class MockDatabaseManager: DatabaseManagerProtocol {
    func getCachedBeers() -> [BeerRealmObject] { return [] }
    func getFavouriteBeers() -> [BeerRealmObject] { return [] }
    func saveBeers(_ beers: [BeerListItem]) {}
    func isFavourite(id: Int) -> Bool { return false }
    func toggleFavourite(id: Int) {}
    func clearCache() {}
}

@Suite("BeerListController basic logic")
@MainActor
struct BeerListControllerTests {

    // toggleFavourites should flip the flag and call updateFavouritesButton
    @Test("toggleFavourites flips flag and calls updateFavouritesButton")
    func testToggleFavourites() async throws {
        let mockView = MockBeerListViewController()
        let controller = BeerListController(view: mockView, database: MockDatabaseManager())

        controller.toggleFavourites()
        #expect(mockView.lastFavouritesActive == true)

        controller.toggleFavourites()
        #expect(mockView.lastFavouritesActive == false)
    }

    // setBeers / getBeers should store and return the same items
    @Test("setBeers stores items retrievable via getBeers")
    func testSetAndGetBeers() async throws {
        let mockView = MockBeerListViewController()
        let controller = BeerListController(view: mockView, database: MockDatabaseManager())

        let items = [
            BeerListItem(id: 1, name: "Punk IPA", tagline: "Post Modern Classic", abv: 5.6),
            BeerListItem(id: 2, name: "Trashy Blonde", tagline: "You Know You Shouldn't", abv: 4.1)
        ]
        controller.setBeers(beers: items)

        let result = controller.getBeers()
        #expect(result.count == 2)
        #expect(result[0].name == "Punk IPA")
        #expect(result[1].id == 2)
    }

    // updateTableView should trigger reloadTableData on the view
    @Test("updateTableView calls reloadTableData on view")
    func testUpdateTableView() async throws {
        let mockView = MockBeerListViewController()
        let controller = BeerListController(view: mockView, database: MockDatabaseManager())

        controller.updateTableView()
        #expect(mockView.didReloadTableData == true)
    }

    // getBeers returns empty array before any beers are set
    @Test("getBeers returns empty array initially")
    func testGetBeersInitiallyEmpty() async throws {
        let mockView = MockBeerListViewController()
        let controller = BeerListController(view: mockView, database: MockDatabaseManager())
        #expect(controller.getBeers().isEmpty)
    }
}
