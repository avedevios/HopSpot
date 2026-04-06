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
    private let networkManager: NetworkManagerProtocol
    
    init(view: BeerDetailViewController, listItem: BeerListItem, networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.view = view
        self.listItem = listItem
        self.networkManager = networkManager
    }
    
    // Called on viewDidLoad — loads full beer details by id
    func loadDetails() {
        guard let id = listItem.id else {
            view.showError("Beer ID not available")
            return
        }
        loadDetails(id: id, completion: nil)
    }

    // Testable overload with optional completion called after the network response
    func loadDetails(id: Int, completion: (() -> Void)? = nil) {
        view.showLoading(true)
        networkManager.getBeerDetails(id: id) { [weak self] beer in
            guard let self = self else { return }
            self.view.showLoading(false)
            if let beer = beer {
                self.beer = beer
                self.view.updateDetails(beer: beer)
            } else {
                self.view.showError("Failed to load beer details")
            }
            completion?()
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
        let malt = maltText(from: ingredients)
        let hops = hopsText(from: ingredients)
        let yeast = ingredients.yeast.map { "\nYeast: \($0)\n" } ?? ""
        let result = malt + hops + yeast
        return result.isEmpty ? "No ingredients information available" : result
    }

    private func maltText(from ingredients: Ingredients) -> String {
        guard let malt = ingredients.malt, !malt.isEmpty else { return "" }
        let lines = malt.compactMap { item -> String? in
            guard let name = item.name, let amount = item.amount else { return nil }
            return "• \(name) - \(amount.value ?? 0) \(amount.unit ?? "")"
        }
        return lines.isEmpty ? "" : "Malt:\n" + lines.joined(separator: "\n") + "\n"
    }

    private func hopsText(from ingredients: Ingredients) -> String {
        guard let hops = ingredients.hops, !hops.isEmpty else { return "" }
        let lines = hops.compactMap { hop -> String? in
            guard let name = hop.name, let amount = hop.amount, let add = hop.add else { return nil }
            return "• \(name) - \(amount.value ?? 0) \(amount.unit ?? "") (\(add))"
        }
        return lines.isEmpty ? "" : "\nHops:\n" + lines.joined(separator: "\n") + "\n"
    }
    
    func getBrewersTipsText() -> String {
        return beer?.brewers_tips ?? "No brewer's tips available"
    }
    
    func getImageURL() -> String? {
        return beer?.image_url
    }
}
