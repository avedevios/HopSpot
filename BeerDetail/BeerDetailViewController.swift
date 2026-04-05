//
//  BeerDetailViewController.swift
//  HopSpot
//
//  Created on 2026-04-04.
//

import UIKit
import SnapKit

class BeerDetailViewController: UIViewController {
    
    private var controller: BeerDetailController!
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var beerImageView: UIImageView!
    private var nameLabel: UILabel!
    private var taglineLabel: UILabel!
    private var activityIndicator: UIActivityIndicatorView!
    private var descriptionLabel: UILabel!
    private var specsStackView: UIStackView!
    private var abvLabel: UILabel!
    private var ibuLabel: UILabel!
    private var ebcLabel: UILabel!
    private var foodPairingLabel: UILabel!
    private var ingredientsLabel: UILabel!
    private var brewersTipsLabel: UILabel!
    
    init(listItem: BeerListItem) {
        super.init(nibName: nil, bundle: nil)
        self.controller = BeerDetailController(view: self, listItem: listItem)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Show what we already have from the list item
        let item = controller.getListItem()
        nameLabel.text = item.name
        taglineLabel.text = item.tagline
        
        // Show placeholder for now, full image loads with details
        beerImageView.image = UIImage(systemName: "photo")
        beerImageView.tintColor = .systemGray
        
        // Kick off async load of full details
        controller.loadDetails()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Beer Details"
        
        setupScrollView()
        setupImageView()
        setupLabels()
        setupActivityIndicator()
        setupConstraints()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        contentView = UIView()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func setupImageView() {
        beerImageView = UIImageView()
        beerImageView.contentMode = .scaleAspectFit
        beerImageView.backgroundColor = .systemGray6
        beerImageView.layer.cornerRadius = 12
        beerImageView.clipsToBounds = true
        contentView.addSubview(beerImageView)
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        contentView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(specsStackView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupLabels() {
        nameLabel = UILabel()
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        
        taglineLabel = UILabel()
        taglineLabel.font = .italicSystemFont(ofSize: 16)
        taglineLabel.textColor = .secondaryLabel
        taglineLabel.numberOfLines = 0
        taglineLabel.textAlignment = .center
        
        descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = ""
        
        specsStackView = UIStackView()
        specsStackView.axis = .vertical
        specsStackView.spacing = 8
        specsStackView.distribution = .fillEqually
        
        abvLabel = createSpecLabel(text: "ABV: —")
        ibuLabel = createSpecLabel(text: "IBU: —")
        ebcLabel = createSpecLabel(text: "EBC: —")
        specsStackView.addArrangedSubview(abvLabel)
        specsStackView.addArrangedSubview(ibuLabel)
        specsStackView.addArrangedSubview(ebcLabel)
        
        foodPairingLabel = UILabel()
        foodPairingLabel.numberOfLines = 0
        foodPairingLabel.text = ""
        
        ingredientsLabel = UILabel()
        ingredientsLabel.numberOfLines = 0
        ingredientsLabel.text = ""
        
        brewersTipsLabel = UILabel()
        brewersTipsLabel.numberOfLines = 0
        brewersTipsLabel.text = ""
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(taglineLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(specsStackView)
        contentView.addSubview(foodPairingLabel)
        contentView.addSubview(ingredientsLabel)
        contentView.addSubview(brewersTipsLabel)
    }
    
    private func createSpecLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = text
        label.backgroundColor = .systemGray6
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 16
        
        beerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(padding)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(beerImageView.snp.bottom).offset(padding)
            make.left.right.equalToSuperview().inset(padding)
        }
        taglineLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(padding)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(taglineLabel.snp.bottom).offset(padding)
            make.left.right.equalToSuperview().inset(padding)
        }
        specsStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(padding)
            make.left.right.equalToSuperview().inset(padding)
            make.height.equalTo(120)
        }
        foodPairingLabel.snp.makeConstraints { make in
            make.top.equalTo(specsStackView.snp.bottom).offset(padding)
            make.left.right.equalToSuperview().inset(padding)
        }
        ingredientsLabel.snp.makeConstraints { make in
            make.top.equalTo(foodPairingLabel.snp.bottom).offset(padding)
            make.left.right.equalToSuperview().inset(padding)
        }
        brewersTipsLabel.snp.makeConstraints { make in
            make.top.equalTo(ingredientsLabel.snp.bottom).offset(padding)
            make.left.right.equalToSuperview().inset(padding)
            make.bottom.equalToSuperview().inset(padding)
        }
    }
    
    // MARK: - Called by controller
    
    func showLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func updateDetails(beer: Beer) {
        descriptionLabel.text = beer.description
        abvLabel.text = controller.getFormattedABV()
        ibuLabel.text = controller.getFormattedIBU()
        ebcLabel.text = controller.getFormattedEBC()
        foodPairingLabel.text = "Food Pairing:\n" + controller.getFoodPairingText()
        ingredientsLabel.text = "Ingredients:\n" + controller.getIngredientsText()
        brewersTipsLabel.text = "Brewer's Tips:\n" + controller.getBrewersTipsText()
        
        // Load image if available
        if let imageURLString = controller.getImageURL(), let imageURL = URL(string: imageURLString) {
            loadImage(from: imageURL)
        }
    }
    
    func showError(_ message: String) {
        descriptionLabel.text = message
    }
    
    // MARK: - Image loading
    
    private func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.beerImageView.image = image
            }
        }
        task.resume()
    }
}
