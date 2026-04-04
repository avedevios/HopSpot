//
//  FavoritesModel.swift
//  HopSpot
//
//  Created by ake11a on 2022-11-20.
//

import Foundation
class FavoritesModel {
    
    private weak var controller: FavoritesController!
    
    private var database = DatabaseManager()
    
    init(controller: FavoritesController!) {
        self.controller = controller
    }
    
    func getFavorites() {
        controller.setFavorites(beers: database.getData())
    }
}
