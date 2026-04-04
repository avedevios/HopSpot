//
//  DatabaseManager.swift
//  HopSpot
//
//  Created by ake11a on 2022-11-20.
//

import Foundation
import RealmSwift

class DatabaseManager {
    
    private var beers: Results<BeerRealmObject>?
    
    private let realm = try! Realm()
    
    func getData() -> Results<BeerRealmObject> {
        beers = realm.objects(BeerRealmObject.self)
        return beers!
    }
    
    func setData(beer: BeerRealmObject) {
        try! realm.write( {
            realm.add(beer)
        })
    }
}
