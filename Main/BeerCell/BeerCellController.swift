//
//  BeerCellController.swift
//  lesson5412
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
    
    func addFavourite(title: String) -> Bool {
        let result = model?.addFavourite(title: title)
        
        return result == nil ? false : result!
    }
}
