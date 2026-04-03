//
//  FavoritesController.swift
//  lesson5412
//
//  Created by ake11a on 2022-11-12.
//

import UIKit
import SnapKit
import RealmSwift

class FavouritesView: UIViewController {
    
    private var controller: FavouritesController!
    
    private lazy var favoritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "fav_cell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.controller = FavouritesController(view: self)

        controller.updateFavourites()
        
        setupSubviews()
    }
    
    func setupSubviews() {
        self.title = "Favourites"
        
        view.backgroundColor = .orange
        favoritesTableView.backgroundColor = .orange
        favoritesTableView.separatorStyle = .none
        
        view.addSubview(favoritesTableView)
        favoritesTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension FavouritesView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.getFavouritesBeers().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fav_cell", for: indexPath)
        cell.backgroundColor = .orange
        cell.textLabel?.text = controller.getFavouritesBeers()[indexPath.row].name
        return cell
    }
}

extension FavouritesView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            controller.deleteFavouriteBeer(index: indexPath.row)
            favoritesTableView.reloadData()
        }
    }
}
