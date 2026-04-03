//
//  DatabaseManager.swift
//  lesson5412
//
//  Created by ake11a on 2022-11-20.
//

import Foundation
import RealmSwift

class DatabaseManager {
    
    private var beers: Results<BeerRealm>?
    
    private let realm = try! Realm()
    
    func getData() -> Results<BeerRealm> {
        beers = realm.objects(BeerRealm.self)
        return beers!
    }
    
    func setData(beer: BeerRealm) {
        try! realm.write( {
            realm.add(beer)
        })
    }
    
    func deleteData(beer: BeerRealm) {
        try! realm.write( {
            realm.delete(beer)
        })
    }
}
