//
//  BeerListController.swift
//  HopSpot
//
//  Created by ake11a on 2022-11-20.
//

import Foundation

class BeerListController {
    
    public weak var view: BeerListViewController!
    
    private var model: BeerListModel?
    
    private var beers: [Beer] = []
    
    init(view: BeerListViewController) {
        self.view = view
        self.model = BeerListModel(controller: self)
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
