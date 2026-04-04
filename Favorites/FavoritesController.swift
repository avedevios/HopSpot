//
//  FavoritesController.swift
//  HopSpot
//
//  Created by ake11a on 2022-11-20.
//

import Foundation
import RealmSwift

class FavoritesController {
   
    public weak var view: FavoritesView!
    
    private var model: FavoritesModel?
    
    private var favoriteBeers: Results<BeerRealmObject>?
    
    init(view: FavoritesView) {
        self.view = view
        self.model = FavoritesModel(controller: self)
    }
    
    func setFavorites(beers: Results<BeerRealmObject>) {
        self.favoriteBeers = beers
    }
    
    func getFavoriteBeers() -> Results<BeerRealmObject> {
        return favoriteBeers!
    }
    
    func updateFavorites() {
        model?.getFavorites()
    }
}
