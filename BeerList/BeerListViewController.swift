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
    private var isLoading = false
    
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
        tableView.register(BeerCell.self, forCellReuseIdentifier: BeerCell.reuseIdentifier)
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
    
    func setupSubviews() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(clearCacheAction))
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
        if isLoading {
            controller.cancelFetch()
        } else {
            controller.fetchFromAPI()
        }
    }
    
    @objc func clearCacheAction() {
        let alert = UIAlertController(title: "Clear cache", message: "All beers will be removed from the local database.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive) { [weak self] _ in
            self?.controller.clearCache()
        })
        present(alert, animated: true)
    }
    
    func setLoading(_ loading: Bool) {
        DispatchQueue.main.async {
            self.isLoading = loading
            if loading {
                let container = UIButton(type: .custom)
                container.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
                container.addTarget(self, action: #selector(self.fetchFromAPIAction), for: .touchUpInside)
                let spinner = UIActivityIndicatorView(style: .medium)
                spinner.frame = container.bounds
                spinner.isUserInteractionEnabled = false
                spinner.startAnimating()
                container.addSubview(spinner)
                self.navigationItem.rightBarButtonItems?[1] = UIBarButtonItem(customView: container)
            } else {
                let btn = UIBarButtonItem(image: UIImage(systemName: "arrow.down.circle"), style: .plain, target: self, action: #selector(self.fetchFromAPIAction))
                self.navigationItem.rightBarButtonItems?[1] = btn
            }
        }
    }
    
    func showFetchDone() {
        DispatchQueue.main.async {
            self.isLoading = false
            let done = UIBarButtonItem(image: UIImage(systemName: "checkmark.circle"), style: .plain, target: nil, action: nil)
            self.navigationItem.rightBarButtonItems?[1] = done
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let btn = UIBarButtonItem(image: UIImage(systemName: "arrow.down.circle"), style: .plain, target: self, action: #selector(self.fetchFromAPIAction))
                self.navigationItem.rightBarButtonItems?[1] = btn
            }
        }
    }
    
    func showFetchError() {
        DispatchQueue.main.async {
            self.isLoading = false
            let err = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: nil, action: nil)
            self.navigationItem.rightBarButtonItems?[1] = err
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let btn = UIBarButtonItem(image: UIImage(systemName: "arrow.down.circle"), style: .plain, target: self, action: #selector(self.fetchFromAPIAction))
                self.navigationItem.rightBarButtonItems?[1] = btn
            }
        }
    }    
    func showPageDone(page: Int, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let iconName = page <= 50 ? "\(page).circle" : "ellipsis.circle"
            let btn = UIBarButtonItem(image: UIImage(systemName: iconName), style: .plain, target: self, action: #selector(self.fetchFromAPIAction))
            self.navigationItem.rightBarButtonItems?[1] = btn
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                guard self.isLoading else { return }
                self.setLoading(true)
                completion()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: BeerCell.reuseIdentifier, for: indexPath) as! BeerCell
        let beer = controller.getBeers()[indexPath.row]
        cell.configure(with: beer, isFavourite: controller.isFavourite(id: beer.id))
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = controller.getBeers()[indexPath.row]
        let detailVC = BeerDetailViewController(listItem: item)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
