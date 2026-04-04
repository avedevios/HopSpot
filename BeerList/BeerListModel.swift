//
//  BeerListModel.swift
//  HopSpot
//
//  Created by ake11a on 2022-11-20.
//

import Foundation

class BeerListModel {
    
    private weak var controller: BeerListController!
    
    private var networkManager = NetworkManager()
    
    init(controller: BeerListController!) {
        self.controller = controller
    }
        
    func getBeers() {
        networkManager.getBeerList { beers in
            self.controller.setBeers(beers: beers)
            self.controller.updateTableView()
        }
    }
}

struct Beer: Codable {
    var name: String
    var tagline: String
    var abv: Double?
}
