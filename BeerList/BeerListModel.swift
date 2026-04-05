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
    private var currentPage = 1
    private let perPage = 30
    
    init(controller: BeerListController!) {
        self.controller = controller
    }
        
    func getBeers() {
        print("🔄 Starting to fetch beers (page \(currentPage))...")
        networkManager.getBeerList(page: currentPage, perPage: perPage) { beers in
            print("📊 Received \(beers.count) beers from network")
            self.controller.setBeers(beers: beers)
            self.controller.updateTableView()
        }
    }
    
    func loadMoreBeers() {
        currentPage += 1
        print("🔄 Loading next page (\(currentPage))...")
        networkManager.getBeerList(page: currentPage, perPage: perPage) { beers in
            print("📊 Received \(beers.count) beers from network (page \(self.currentPage))")
            if !beers.isEmpty {
                self.controller.addBeers(beers: beers)
            } else {
                print("⚠️ No more beers to load")
                self.currentPage -= 1
            }
        }
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
