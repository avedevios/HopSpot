# HopSpot 🍺

A study iOS project built as part of the [GEEKS](https://geeks.kg) programming course.

An app for browsing a beer catalogue — list, detail screen, favourites, and local cache.

---

## Tech Stack

### UIKit
The entire UI is built with UIKit, without Storyboard (except LaunchScreen). All screens are created in code via `init`, and constraints are set programmatically.

### SnapKit
A library for writing Auto Layout constraints with a clean DSL instead of verbose NSLayoutConstraint:

```swift
view.snp.makeConstraints { make in
    make.top.equalToSuperview().offset(16)
    make.left.right.equalToSuperview().inset(16)
}
```

### RealmSwift
Local database for caching the beer list and storing favourites. On launch the app immediately shows cached data without waiting for the network.

```swift
class BeerRealmObject: Object {
    @Persisted(primaryKey: true) var id: Int?
    @Persisted var name: String = ""
    @Persisted var isFavorite: Bool = false
}
```

### URLSession
The networking layer is built on native `URLSession` without third-party libraries. Supports pagination and request cancellation.

### Swift Testing
A unit testing framework introduced in Swift 5.9. Used to cover controllers and formatting logic.

```swift
@Test("getFormattedABV falls back to listItem abv")
func testABVFromListItem() {
    let item = BeerListItem(id: 1, name: "Punk IPA", tagline: "...", abv: 4.2)
    let controller = BeerDetailController(view: mockView, listItem: item, networkManager: MockNetworkManager())
    #expect(controller.getFormattedABV() == "ABV 4.2%")
}
```

---

## Architecture

The project follows the **MVC** pattern with a clear separation into three layers:

```
View (UIViewController)
    ↕
Controller — coordinates logic, unaware of UI details
    ↕
Model (Network / Database) — data and business logic
```

Each screen has its own trio: `ViewController` → `Controller` → `Model`.

### Dependency Injection
To keep the code testable, `NetworkManager` and `DatabaseManager` are hidden behind protocols. Tests use mocks — no real network or database is touched:

```swift
protocol NetworkManagerProtocol {
    func getBeerDetails(id: Int, completion: @escaping (Beer?) -> ())
}

// In tests:
class MockNetworkManager: NetworkManagerProtocol {
    var beerToReturn: Beer? = nil
    func getBeerDetails(id: Int, completion: @escaping (Beer?) -> ()) {
        completion(beerToReturn)
    }
}
```

---

## Screens

### Beer List
- Loads data from local cache on launch
- Fetch from API button — paginated, with a progress indicator
- Filter by favourites
- Cached records counter in the navigation bar
- Clear cache action

### Beer Detail
- ABV, IBU, EBC specs
- Ingredients: malt, hops, yeast
- Food pairing and brewer's tips
- Beer image

---

## Tests

22 unit tests across two suites:

- `BeerListController` — toggle favourites, set/get beers, view callbacks
- `BeerDetailController` — ABV/IBU/EBC formatting, ingredients, food pairing, load details scenarios

---

## Requirements

- iOS 13+
- Xcode 15+

---

## Credits

Beer data provided by [alxiw/punkapi](https://github.com/alxiw/punkapi) — a FastAPI archive of the BrewDog DIY Dog catalogue.
