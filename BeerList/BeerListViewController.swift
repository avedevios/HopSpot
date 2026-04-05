//
//  BeerListViewController.swift
//  HopSpot
//
//  Created by ake11a on 2022-11-12.
//

import UIKit
import SnapKit

class BeerListViewController: UIViewController {
    
    private var controller: BeerListController!
    
    private lazy var beersTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BeerCell.self, forCellReuseIdentifier: "beer_cell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.controller = BeerListController(view: self)
        
        setupSubviews()
        
        controller.updateBeerList()
        
    }

    func reloadTableData() {
        DispatchQueue.main.async {
            self.beersTableView.reloadData()
        }
    }
    
    func insertRows(indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.beersTableView.performBatchUpdates({
                self.beersTableView.insertRows(at: indexPaths, with: .automatic)
            })
        }
    }
    
    func beginTableUpdate() {
        // Not needed anymore
    }
    
    func endTableUpdate() {
        // Not needed anymore
    }
    
    func setupSubviews() {
        
        navigationItem.rightBarButtonItem = createFavoritesBarButton(image: "heart.fill", selector: #selector(favoritesBarButtonAction))
        
        view.addSubview(beersTableView)
        beersTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func favoritesBarButtonAction() {
        navigationController?.pushViewController(FavoritesView(), animated: true)
    }
}

extension BeerListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = controller.getBeers().count
        print("📋 Table view asking for rows, returning: \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beer_cell", for: indexPath) as! BeerCell
        let beer = controller.getBeers()[indexPath.row]
        cell.beerNameLabel.text = beer.name
        let abvText = beer.abv.map { String(format: "ABV %.1f%%", $0) } ?? "ABV n/a"
        cell.beerSubtitleLabel.text = "\(beer.tagline) • \(abvText)"
        return cell
    }
}

extension BeerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete logic")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = controller.getBeers()[indexPath.row]
        let detailVC = BeerDetailViewController(listItem: item)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalBeers = controller.getBeers().count
        // Load more when user scrolls to last 10 rows
        if indexPath.row == totalBeers - 10 {
            print("📍 Loading more beers...")
            controller.loadMoreBeers()
        }
    }
}
