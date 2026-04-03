//
//  ViewController.swift
//  lesson5412
//
//  Created by ake11a on 2022-11-12.
//

import UIKit

class ViewController: UIViewController {
    
    private var controller: BeerController!
    
    private var filteredBeers: [Beer] = []
    
    private lazy var beersSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var favouritesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.circle.fill")
        imageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(favoritesBarButtonAction))
        imageView.addGestureRecognizer(tap)
        
        return imageView
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
        
        self.controller = BeerController(view: self)
        
        setupSubviews()
        
        controller.updateBeerList()
        
    }

    func reloadTableData() {
        DispatchQueue.main.async {
            self.filteredBeers = self.controller.getBeers()
            self.beersTableView.reloadData()
        }
    }
    
    func setupSubviews() {
        view.backgroundColor = .black
        beersTableView.backgroundColor = .orange
        beersTableView.separatorStyle = .none
        
//        navigationItem.rightBarButtonItem = createFavoritesBarButton(image: "heart.fill", selector: #selector(favoritesBarButtonAction))
        
        view.addSubview(beersSearchBar)
        beersSearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-80)
            make.height.equalTo(50)
        }
        
        view.addSubview(favouritesImageView)
        favouritesImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(beersSearchBar.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        view.addSubview(beersTableView)
        beersTableView.snp.makeConstraints { make in
            make.top.equalTo(beersSearchBar.snp.bottom).offset(10)
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
        return filteredBeers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beer_cell", for: indexPath) as! BeerCell
        
//        let url = URL(string: filteredBeers[indexPath.row].image_url)
//        if let data = try? Data(contentsOf: url!)
//        {
//            cell.beerImageView.image = UIImage(data: data)
//        }
        var beerImage = UIImage(named: "Bottle")
//        let beerPictureURL = URL(string: filteredBeers[indexPath.row].image_url)!
//
//        // Creating a session object with the default configuration.
//        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
//        let session = URLSession(configuration: .default)
//
//        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
//        let downloadPicTask = session.dataTask(with: beerPictureURL) { (data, response, error) in
//            // The download has finished.
//            if let e = error {
//                print("Error downloading beer picture: \(e)")
//            } else {
//                // No errors found.
//                // It would be weird if we didn't have a response, so check for that too.
//                if let res = response as? HTTPURLResponse {
//                    print("Downloaded beer picture with response code \(res.statusCode)")
//                    if let imageData = data {
//                        // Finally convert that Data into an image and do what you wish with it.
//                        beerImage  = UIImage(data: imageData)
//                        // Do something with your image.
//                    } else {
//                        print("Couldn't get image: Image is nil")
//                    }
//                } else {
//                    print("Couldn't get response code for some reason")
//                }
//            }
//        }
//
//        downloadPicTask.resume()

        cell.beerImageView.image = beerImage
        cell.beerNameLabel.text = filteredBeers[indexPath.row].name
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
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

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredBeers = []
        
        if searchText == "" {
            filteredBeers = controller.getBeers()
        }
        
        for beer in controller.getBeers() {
            if beer.name.uppercased().contains(searchText.uppercased()) {
                filteredBeers.append(beer)
            }
        }
        
        beersTableView.reloadData()
    }
}
