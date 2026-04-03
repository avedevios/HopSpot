//
//  BeerCellModel.swift
//  lesson5412
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
    
    func addFavourite(title: String) -> Bool {
        var isAddable = true
        
        let currentFavourites = database.getData()
        for favourite in currentFavourites {
            if favourite.name == title {
                database.deleteData(beer: favourite)
                
                isAddable = false
            }
        }
        
        if isAddable {
            let beer = BeerRealm()
            beer.name = title
            
            database.setData(beer: beer)
        }
        return isAddable
    }
}
