//
//  FavouritesModel.swift
//  lesson5412
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
    
    func deleteFavouriteBeer(index: Int) {
        let beers = database.getData()
        database.deleteData(beer: beers[index])
    }
}

class BeerRealm: Object {
    @objc dynamic var name = ""
}
