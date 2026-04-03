//
//  ViewController.swift
//  lesson5412
//
//  Created by ake11a on 2022-11-12.
//

import UIKit

class ViewController: UIViewController {
    
    private var controller: BeerController!
    
    private lazy var beersTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BeerCell.self, forCellReuseIdentifier: "beer_cell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.controller = BeerController(view: self)
        
        setupSubviews()
        
        controller.updateBeerList()
        
    }

    func reloadTableData() {
        DispatchQueue.main.async {
            self.beersTableView.reloadData()
        }
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
        navigationController?.pushViewController(FavouritesView(), animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.getBeers().count
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

extension ViewController: UITableViewDelegate {
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
}
