//
//  BeerRealmObject.swift
//  HopSpot
//
//  Created by ake11a on 2022-11-20.
//

import Foundation
import RealmSwift

class BeerRealmObject: Object {
    @Persisted(primaryKey: true) var id: Int?
    @Persisted var name: String = ""
    @Persisted var tagline: String = ""
    @Persisted var abv: Double?
    @Persisted var isFavorite: Bool = false
}

