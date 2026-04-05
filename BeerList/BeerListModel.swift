//
//  BeerListModel.swift
//  HopSpot
//
//  Created by ake11a on 2022-11-20.
//

import Foundation

class BeerListModel {
    
    private weak var controller: BeerListController!
    
    private var networkManager = NetworkManager()
    private var database = DatabaseManager()
    private let perPage = 50
    private var isCancelled = false
    
    init(controller: BeerListController!) {
        self.controller = controller
    }
        
    func getBeers() {
        // Load only from cache on start
        let cachedBeers = database.getCachedBeers()
        print("💾 Loaded \(cachedBeers.count) beers from cache")
        let cacheItems = cachedBeers.map { BeerListItem(id: $0.id, name: $0.name, tagline: $0.tagline, abv: $0.abv) }
        controller.setBeers(beers: cacheItems)
        controller.updateTableView()
    }
    
    func getFavourites() {
        let favourites = database.getFavouriteBeers()
        let items = favourites.map { BeerListItem(id: $0.id, name: $0.name, tagline: $0.tagline, abv: $0.abv) }
        controller.setBeers(beers: items)
        controller.updateTableView()
    }
    
    func fetchFromAPI() {
        print("🌐 Fetching all beers from API...")
        isCancelled = false
        controller.setLoading(true)
        fetchPage(1)
    }
    
    func cancelFetch() {
        isCancelled = true
    }
    
    private func fetchPage(_ page: Int) {
        guard !isCancelled else {
            print("🛑 Fetch cancelled before page \(page)")
            controller.showFetchDone()
            return
        }
        guard page <= 50 else {
            print("⚠️ Page limit reached, stopping fetch")
            controller.showFetchDone()
            reloadFromCache()
            return
        }
        networkManager.getBeerList(page: page, perPage: perPage) { beers, isTimeout in
            if isTimeout {
                print("⏱ Timeout on page \(page)")
                self.controller.showFetchError()
                return
            }
            if beers.isEmpty {
                print("✅ All pages fetched, reloading from cache")
                self.controller.showFetchDone()
                self.reloadFromCache()
            } else {
                print("📊 Page \(page): received \(beers.count) beers, saving to cache")
                self.database.saveBeers(beers)
                self.reloadFromCache()
                if self.isCancelled {
                    print("🛑 Fetch cancelled after page \(page)")
                    self.controller.showFetchDone()
                    return
                }
                self.controller.showPageDone(page: page) {
                    self.fetchPage(page + 1)
                }
            }
        }
    }
    
    private func reloadFromCache() {
        let cached = database.getCachedBeers()
        let items = cached.map { BeerListItem(id: $0.id, name: $0.name, tagline: $0.tagline, abv: $0.abv) }
        self.controller.setBeers(beers: items)
        self.controller.updateTableView()
        self.controller.updateCacheCount()
    }
    
    func getCacheCount() -> Int {
        return database.getCachedBeers().count
    }
    
    func clearCache() {
        database.clearCache()
        controller.setBeers(beers: [])
        controller.updateTableView()
        controller.updateCacheCount()
    }
    
    func isFavourite(id: Int) -> Bool {
        return database.isFavourite(id: id)
    }
}

// Lightweight model — used only in the list. Decodes fast.
struct BeerListItem: Codable {
    var id: Int?
    var name: String
    var tagline: String
    var abv: Double?
}

// Full model — used only on the detail screen.
struct Beer: Codable {
    var id: Int?
    var name: String
    var tagline: String
    var description: String?
    var abv: Double?
    var ibu: Double?
    var ebc: Double?
    var srm: Double?
    var ph: Double?
    var food_pairing: [String]?
    var brewers_tips: String?
    var image: String?
    var ingredients: Ingredients?
    var method: Method?
    
    var image_url: String? {
        guard let image = image else { return nil }
        return "https://punkapi-alxiw.amvera.io/v3/images/\(image)"
    }
}

struct Ingredients: Codable {
    var malt: [Malt]?
    var hops: [Hop]?
    var yeast: String?
}

struct Malt: Codable {
    var name: String?
    var amount: Amount?
}

struct Hop: Codable {
    var name: String?
    var amount: Amount?
    var add: String?
    var attribute: String?
}

struct Amount: Codable {
    var value: Double?
    var unit: String?
}

struct Method: Codable {
    var mash_temp: [MashTemp]?
    var fermentation: Fermentation?
    var twist: String?
}

struct MashTemp: Codable {
    var temp: Temperature?
    var duration: Int?
}

struct Fermentation: Codable {
    var temp: Temperature?
}

struct Temperature: Codable {
    var value: Double?
    var unit: String?
}
