//
//  BeerModel.swift
//  lesson5412
//
//  Created by ake11a on 2022-11-20.
//

import Foundation

class BeerModel {
    
    private weak var controller: BeerController!
    
    private var networkManager = NetworkManager()
    
    init(controller: BeerController!) {
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
    var image_url: String
}
