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
    @Persisted var descriptionText: String = ""
    @Persisted var abv: Double?
    @Persisted var ibu: Double?
    @Persisted var ebc: Double?
    @Persisted var srm: Double?
    @Persisted var ph: Double?
    @Persisted var image: String?
    @Persisted var brewers_tips: String?
    @Persisted var foodPairing: String?
    @Persisted var ingredients: String?
    @Persisted var method: String?
    @Persisted var isFavorite: Bool = false
}

