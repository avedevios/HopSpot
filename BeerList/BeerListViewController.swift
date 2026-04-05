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
    
    private let cacheCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.text = "0"
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        return label
    }()
    
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
        controller.updateCacheCount()
        
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
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favoritesBarButtonAction)),
            UIBarButtonItem(image: UIImage(systemName: "arrow.down.circle"), style: .plain, target: self, action: #selector(fetchFromAPIAction))
        ]
        navigationItem.titleView = cacheCountLabel
        
        view.addSubview(beersTableView)
        beersTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func favoritesBarButtonAction() {
        controller.toggleFavourites()
    }
    
    func updateFavouritesButton(active: Bool) {
        let icon = active ? "heart.fill" : "heart"
        navigationItem.rightBarButtonItems?[0] = UIBarButtonItem(image: UIImage(systemName: icon), style: .plain, target: self, action: #selector(favoritesBarButtonAction))
    }
    
    @objc func fetchFromAPIAction() {
        controller.fetchFromAPI()
    }
    
    func setLoading(_ loading: Bool) {
        DispatchQueue.main.async {
            if loading {
                let spinner = UIActivityIndicatorView(style: .medium)
                spinner.startAnimating()
                self.navigationItem.rightBarButtonItems?[1] = UIBarButtonItem(customView: spinner)
            } else {
                let btn = UIBarButtonItem(image: UIImage(systemName: "arrow.down.circle"), style: .plain, target: self, action: #selector(self.fetchFromAPIAction))
                self.navigationItem.rightBarButtonItems?[1] = btn
            }
        }
    }
    
    func setCacheCount(_ count: Int) {
        DispatchQueue.main.async {
            self.cacheCountLabel.text = "\(count)"
        }
    }
}

extension BeerListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.getBeers().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beer_cell", for: indexPath) as! BeerCell
        let beer = controller.getBeers()[indexPath.row]
        cell.configure(with: beer, isFavourite: controller.isFavourite(id: beer.id))
        cell.beerNameLabel.text = beer.name
        let abvText = beer.abv.map { String(format: "ABV %.1f%%", $0) } ?? "ABV n/a"
        cell.beerSubtitleLabel.text = "\(beer.tagline) • \(abvText)"
        cell.onFavouriteToggled = { [weak self] in
            self?.controller.refreshIfNeeded()
        }
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
        print("🍺 BeerListViewController: Selected beer at row \(indexPath.row): id=\(item.id ?? 0), name='\(item.name)'")
        let detailVC = BeerDetailViewController(listItem: item)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}
