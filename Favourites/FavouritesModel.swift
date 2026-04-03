//
//  FavouritesModel.swift
//  HopSpot
//
//  Created by ake11a on 2022-11-20.
//

import Foundation
import RealmSwift

class FavouritesModel {
    
    private weak var controller: FavouritesController!
    
    private var database = DatabaseManager()
    
    init(controller: FavouritesController!) {
        self.controller = controller
    }
    
    func getFavourites() {
        controller.setFavourites(beers: database.getData())
    }
}

class BeerRealm: Object {
    @objc dynamic var name = ""
}
