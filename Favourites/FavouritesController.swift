//
//  FavouritesController.swift
//  lesson5412
//
//  Created by ake11a on 2022-11-20.
//

import Foundation
import RealmSwift

class FavouritesController {
   
    public weak var view: FavouritesView!
    
    private var model: FavouritesModel?
    
    private var favouriteBeers: Results<BeerRealm>?
    
    init(view: FavouritesView) {
        self.view = view
        self.model = FavouritesModel(controller: self)
    }
    
    func setFavourites(beers: Results<BeerRealm>) {
        self.favouriteBeers = beers
    }
    
    func getFavouritesBeers() -> Results<BeerRealm> {
        return favouriteBeers!
    }
    
    func deleteFavouriteBeer(index: Int) {
        model?.deleteFavouriteBeer(index: index)
    }
    
    func updateFavourites() {
        model?.getFavourites()
    }
}

