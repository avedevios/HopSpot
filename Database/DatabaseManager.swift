//
//  DatabaseManager.swift
//  HopSpot
//
//  Created by ake11a on 2022-11-20.
//

import Foundation
import RealmSwift

class DatabaseManager {
    
    private let realm: Realm
    
    init() {
        // Configure Realm to delete old DB if migration is needed (for development)
        var config = Realm.Configuration.defaultConfiguration
        config.deleteRealmIfMigrationNeeded = true
        
        self.realm = try! Realm(configuration: config)
        print("💾 Realm database initialized at: \(config.fileURL?.path ?? "unknown")")
    }
    
    // Get all cached beers
    func getCachedBeers() -> [BeerRealmObject] {
        return Array(realm.objects(BeerRealmObject.self))
    }
    
    // Get only favourite beers
    func getFavouriteBeers() -> [BeerRealmObject] {
        return Array(realm.objects(BeerRealmObject.self).where { $0.isFavorite == true })
    }
    
    // Clear all cached beers
    func clearCache() {
        do {
            try realm.write {
                realm.deleteAll()
            }
            print("💾 Cache cleared")
        } catch {
            print("❌ Error clearing cache: \(error)")
        }
    }
    
    // Save or update beer in cache
    func saveBeer(_ beer: BeerListItem) {
        do {
            try realm.write {
                let realmBeer = BeerRealmObject()
                realmBeer.id = beer.id
                realmBeer.name = beer.name
                realmBeer.tagline = beer.tagline
                realmBeer.abv = beer.abv
                realm.add(realmBeer, update: .modified)
            }
        } catch {
            print("❌ Error saving beer to cache: \(error)")
        }
    }
    
    // Save multiple beers
    func saveBeers(_ beers: [BeerListItem]) {
        do {
            try realm.write {
                for beer in beers {
                    let realmBeer = BeerRealmObject()
                    realmBeer.id = beer.id
                    realmBeer.name = beer.name
                    realmBeer.tagline = beer.tagline
                    realmBeer.abv = beer.abv
                    realm.add(realmBeer, update: .modified)
                }
            }
        } catch {
            print("❌ Error saving beers to cache: \(error)")
        }
    }
    
    // Check if beer exists in cache
    func beerExists(withId id: Int?) -> Bool {
        guard let id = id else { return false }
        return realm.objects(BeerRealmObject.self).where { $0.id == id }.count > 0
    }
    
    func isFavourite(id: Int) -> Bool {
        return realm.objects(BeerRealmObject.self).where { $0.id == id }.first?.isFavorite ?? false
    }
    func toggleFavourite(id: Int) {
        guard let beer = realm.objects(BeerRealmObject.self).where({ $0.id == id }).first else { return }
        do {
            try realm.write {
                beer.isFavorite = !beer.isFavorite
            }
            print("💾 Beer '\(beer.name)' isFavorite = \(beer.isFavorite)")
        } catch {
            print("❌ Error toggling favourite: \(error)")
        }
    }

    // Legacy method for favorites (kept for compatibility)
    func setData(beer: BeerRealmObject) {
        do {
            try realm.write {
                realm.add(beer, update: .modified)
            }
        } catch {
            print("❌ Error saving beer: \(error)")
        }
    }
    
    // Get all data (for favorites compatibility)
    func getData() -> Results<BeerRealmObject> {
        return realm.objects(BeerRealmObject.self)
    }
    
    // Save full beer details to cache
    func saveBeerDetails(_ beer: Beer) {
        do {
            try realm.write {
                let realmBeer = BeerRealmObject()
                realmBeer.id = beer.id
                realmBeer.name = beer.name
                realmBeer.tagline = beer.tagline
                realmBeer.abv = beer.abv
                realmBeer.descriptionText = beer.description ?? ""
                realmBeer.ibu = beer.ibu
                realmBeer.ebc = beer.ebc
                realmBeer.srm = beer.srm
                realmBeer.ph = beer.ph
                realmBeer.image = beer.image_url
                realmBeer.brewers_tips = beer.brewers_tips
                
                // Convert complex objects to JSON strings
                if let foodPairing = beer.food_pairing {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: foodPairing),
                       let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                        realmBeer.foodPairing = jsonString
                    }
                }
                
                if let ingredients = beer.ingredients {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: [
                        "malt": ingredients.malt?.map { ["name": $0.name, "amount": ["value": $0.amount?.value, "unit": $0.amount?.unit]] },
                        "hops": ingredients.hops?.map { ["name": $0.name, "amount": ["value": $0.amount?.value, "unit": $0.amount?.unit], "add": $0.add] },
                        "yeast": ingredients.yeast
                    ]),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        realmBeer.ingredients = jsonString
                    }
                }
                
                if let method = beer.method {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: [
                        "mash_temp": method.mash_temp?.map { ["temp": ["value": $0.temp?.value, "unit": $0.temp?.unit], "duration": $0.duration] },
                        "fermentation": method.fermentation != nil ? ["temp": ["value": method.fermentation?.temp?.value, "unit": method.fermentation?.temp?.unit]] : nil,
                        "twist": method.twist
                    ]),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        realmBeer.method = jsonString
                    }
                }
                
                realm.add(realmBeer, update: .modified)
            }
        } catch {
            print("❌ Error saving beer details to cache: \(error)")
        }
    }
    
    // Get cached beer details by ID
    func getCachedBeerDetails(id: Int) -> BeerRealmObject? {
        return realm.objects(BeerRealmObject.self).where { $0.id == id }.first
    }
    
    // Convert cached beer back to Beer model
    func convertToBeer(_ realmBeer: BeerRealmObject) -> Beer? {
        guard let id = realmBeer.id else { return nil }
        
        var beer = Beer(
            id: id,
            name: realmBeer.name,
            tagline: realmBeer.tagline,
            description: realmBeer.descriptionText,
            abv: realmBeer.abv,
            ibu: realmBeer.ibu,
            ebc: realmBeer.ebc,
            srm: realmBeer.srm,
            ph: realmBeer.ph,
            food_pairing: nil,
            brewers_tips: realmBeer.brewers_tips,
            image: realmBeer.image,
            ingredients: nil,
            method: nil
        )
        
        // Parse JSON strings back to objects
        if let foodPairingJson = realmBeer.foodPairing,
           let jsonData = foodPairingJson.data(using: .utf8),
           let foodPairing = try? JSONSerialization.jsonObject(with: jsonData) as? [String] {
            beer.food_pairing = foodPairing
        }
        
        // For simplicity, we'll skip ingredients and method parsing for now
        // They can be loaded from API if needed
        
        return beer
    }
}
