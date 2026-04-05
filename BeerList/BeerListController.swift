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
    
    private var beers: [BeerListItem] = []
    private var showingFavourites = false
    
    init(view: BeerListViewController) {
        self.view = view
        self.model = BeerListModel(controller: self)
    }
    
    func updateTableView() {
        view.reloadTableData()
    }
    
    func insertNewRows(count: Int) {
        let startIndex = beers.count - count
        var indexPaths: [IndexPath] = []
        for i in 0..<count {
            indexPaths.append(IndexPath(row: startIndex + i, section: 0))
        }
        view.insertRows(indexPaths: indexPaths)
    }
    
    func setBeers(beers: [BeerListItem]) {
        print("📝 Controller received \(beers.count) beers")
        self.beers = beers
    }
    
    func addBeers(beers: [BeerListItem]) {
        print("📝 Controller adding \(beers.count) beers")
        self.beers.append(contentsOf: beers)
        insertNewRows(count: beers.count)
    }
    
    func getBeers() -> [BeerListItem] {
        return beers
    }
    
    func updateBeerList() {
        model?.getBeers()
    }
    
    func toggleFavourites() {
        showingFavourites = !showingFavourites
        view.updateFavouritesButton(active: showingFavourites)
        if showingFavourites {
            model?.getFavourites()
        } else {
            model?.getBeers()
        }
    }
    
    func refreshIfNeeded() {
        guard showingFavourites else { return }
        model?.getFavourites()
    }
    
    func fetchFromAPI() {
        model?.fetchFromAPI()
    }
    
    func isFavourite(id: Int?) -> Bool {
        guard let id = id else { return false }
        return model?.isFavourite(id: id) ?? false
    }
    
    func setLoading(_ loading: Bool) {
        view.setLoading(loading)
    }
    
    func updateCacheCount() {
        view.setCacheCount(model?.getCacheCount() ?? 0)
    }
}
