//
//  FavoritesController.swift
//  HopSpot
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
        //tableView.delegate = self
        return tableView
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.controller = FavouritesController(view: self)

        controller.updateFavourites()
        
        setupSubviews()
    }
    
    func setupSubviews() {
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
        cell.textLabel?.text = controller.getFavouritesBeers()[indexPath.row].name
        return cell
    }
    
    
}
