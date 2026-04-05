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
    
    func setBeers(beers: [BeerListItem]) {
        self.beers = beers
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
    
    func cancelFetch() {
        model?.cancelFetch()
    }
    
    func clearCache() {
        model?.clearCache()
    }
    
    func isFavourite(id: Int?) -> Bool {
        guard let id = id else { return false }
        return model?.isFavourite(id: id) ?? false
    }
    
    func setLoading(_ loading: Bool) {
        view.setLoading(loading)
    }
    
    func showFetchDone() {
        view.showFetchDone()
    }
    
    func showFetchError() {
        view.showFetchError()
    }
    
    func showPageDone(page: Int, completion: @escaping () -> Void) {
        view.showPageDone(page: page, completion: completion)
    }
    
    func updateCacheCount() {
        view.setCacheCount(model?.getCacheCount() ?? 0)
    }
}
