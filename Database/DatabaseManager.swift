//
//  DatabaseManager.swift
//  HopSpot
//
//  Created by ake11a on 2022-11-20.
//

import Foundation
import RealmSwift

class DatabaseManager {
    
    private var realm: Realm?
    
    init() {
        var config = Realm.Configuration.defaultConfiguration
        config.deleteRealmIfMigrationNeeded = true
        do {
            self.realm = try Realm(configuration: config)
        } catch {
            print("❌ Realm init failed: \(error)")
        }
    }
    
    func getCachedBeers() -> [BeerRealmObject] {
        guard let realm = realm else { return [] }
        return Array(realm.objects(BeerRealmObject.self))
    }
    
    func getFavouriteBeers() -> [BeerRealmObject] {
        guard let realm = realm else { return [] }
        return Array(realm.objects(BeerRealmObject.self).where { $0.isFavorite == true })
    }
    
    func saveBeers(_ beers: [BeerListItem]) {
        guard let realm = realm else { return }
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
            print("❌ Error saving beers: \(error)")
        }
    }
    
    func isFavourite(id: Int) -> Bool {
        return realm?.objects(BeerRealmObject.self).where { $0.id == id }.first?.isFavorite ?? false
    }
    
    func toggleFavourite(id: Int) {
        guard let realm = realm,
              let beer = realm.objects(BeerRealmObject.self).where({ $0.id == id }).first else { return }
        do {
            try realm.write {
                beer.isFavorite = !beer.isFavorite
            }
        } catch {
            print("❌ Error toggling favourite: \(error)")
        }
    }
    
    func clearCache() {
        guard let realm = realm else { return }
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("❌ Error clearing cache: \(error)")
        }
    }
    
    func getData() -> Results<BeerRealmObject>? {
        return realm?.objects(BeerRealmObject.self)
    }
}
