//
//  BeerCellModel.swift
//  HopSpot
//
//  Created by ake11a on 2022-11-20.
//

import Foundation

class BeerCellModel {
    private weak var controller: BeerCellController!
    
    private var database = DatabaseManager()
    
    init(controller: BeerCellController!) {
        self.controller = controller
    }
    
    func toggleFavourite(id: Int) {
        database.toggleFavourite(id: id)
    }
    
    func isFavourite(id: Int) -> Bool {
        return database.isFavourite(id: id)
    }
}
