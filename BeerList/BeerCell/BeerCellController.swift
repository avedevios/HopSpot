//
//  BeerCellController.swift
//  HopSpot
//
//  Created by ake11a on 2022-11-20.
//

import Foundation

class BeerCellController {
    private weak var view: BeerCell!
    
    private var model: BeerCellModel?
    
    init(view: BeerCell) {
        self.view = view
        self.model = BeerCellModel(controller: self)
    }
    
    func toggleFavourite(id: Int) {
        model?.toggleFavourite(id: id)
    }
    
    func isFavourite(id: Int) -> Bool {
        return model?.isFavourite(id: id) ?? false
    }
}
