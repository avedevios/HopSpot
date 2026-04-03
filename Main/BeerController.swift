//
//  BeerController.swift
//  lesson5412
//
//  Created by ake11a on 2022-11-20.
//

import Foundation

class BeerController {
    
    public weak var view: ViewController!
    
    private var model: BeerModel?
    
    private var beers: [Beer] = []
    
    init(view: ViewController) {
        self.view = view
        self.model = BeerModel(controller: self)
    }
    
    func updateTableView() {
        view.reloadTableData()
    }
    
    func setBeers(beers: [Beer]) {
        self.beers = beers
    }
    
    func getBeers() -> [Beer] {
        return beers
    }
    
    func updateBeerList() {
        model?.getBeers()
    }
}
