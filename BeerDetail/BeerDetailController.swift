//
//  BeerDetailController.swift
//  HopSpot
//
//  Created on 2026-04-04.
//

import Foundation

class BeerDetailController {
    
    public weak var view: BeerDetailViewController!
    
    private let listItem: BeerListItem
    private var beer: Beer?
    private let networkManager = NetworkManager()
    private let database = DatabaseManager()
    
    init(view: BeerDetailViewController, listItem: BeerListItem) {
        self.view = view
        self.listItem = listItem
    }
    
    // Called on viewDidLoad — loads full beer details by id
    func loadDetails() {
        let startTime = Date()
        print("🍺 BeerDetailController: Loading details for beer id=\(listItem.id ?? 0), name='\(listItem.name)'")
        
        guard let id = listItem.id else {
            print("❌ BeerDetailController: No beer ID available")
            view.showError("Beer ID not available")
            return
        }
        
        // First, check cache
        if let cachedBeerDetails = database.getCachedBeerDetails(id: id),
           let beer = database.convertToBeer(cachedBeerDetails) {
            let loadTime = Date().timeIntervalSince(startTime)
            print("💾 BeerDetailController: Loaded details from cache for '\(beer.name)' in \(String(format: "%.3f", loadTime))s")
            self.beer = beer
            self.view.updateDetails(beer: beer)
            return
        }
        
        // If not in cache, load from API
        view.showLoading(true)
        networkManager.getBeerDetails(id: id) { [weak self] beer in
            guard let self = self else { return }
            let loadTime = Date().timeIntervalSince(startTime)
            self.view.showLoading(false)
            if let beer = beer {
                print("✅ BeerDetailController: Successfully loaded details for '\(beer.name)' from API in \(String(format: "%.2f", loadTime))s")
                self.beer = beer
                // Save to cache for future use
                self.database.saveBeerDetails(beer)
                self.view.updateDetails(beer: beer)
            } else {
                print("❌ BeerDetailController: Failed to load beer details after \(String(format: "%.2f", loadTime))s")
                self.view.showError("Failed to load beer details")
            }
        }
    }
    
    // Immediately available from the list item
    func getListItem() -> BeerListItem { return listItem }
    
    // Available after loadDetails completes
    func getFormattedABV() -> String {
        guard let abv = beer?.abv ?? listItem.abv else { return "ABV n/a" }
        return String(format: "ABV %.1f%%", abv)
    }
    
    func getFormattedIBU() -> String {
        guard let ibu = beer?.ibu else { return "IBU n/a" }
        return String(format: "IBU %.0f", ibu)
    }
    
    func getFormattedEBC() -> String {
        guard let ebc = beer?.ebc else { return "EBC n/a" }
        return String(format: "EBC %.0f", ebc)
    }
    
    func getFoodPairingText() -> String {
        guard let foodPairing = beer?.food_pairing, !foodPairing.isEmpty else {
            return "No food pairing recommendations"
        }
        return foodPairing.joined(separator: "\n")
    }
    
    func getIngredientsText() -> String {
        guard let ingredients = beer?.ingredients else {
            return "No ingredients information available"
        }
        var result = ""
        if let malt = ingredients.malt, !malt.isEmpty {
            result += "Malt:\n"
            for maltItem in malt {
                if let name = maltItem.name, let amount = maltItem.amount {
                    result += "• \(name) - \(amount.value ?? 0) \(amount.unit ?? "")\n"
                }
            }
        }
        if let hops = ingredients.hops, !hops.isEmpty {
            result += "\nHops:\n"
            for hop in hops {
                if let name = hop.name, let amount = hop.amount, let add = hop.add {
                    result += "• \(name) - \(amount.value ?? 0) \(amount.unit ?? "") (\(add))\n"
                }
            }
        }
        if let yeast = ingredients.yeast {
            result += "\nYeast: \(yeast)\n"
        }
        return result.isEmpty ? "No ingredients information available" : result
    }
    
    func getBrewersTipsText() -> String {
        return beer?.brewers_tips ?? "No brewer's tips available"
    }
    
    func getImageURL() -> String? {
        return beer?.image_url
    }
}
