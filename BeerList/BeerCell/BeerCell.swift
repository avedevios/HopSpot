//
//  BeerCell.swift
//  HopSpot
//
//  Created by ake11a on 2022-11-12.
//

import UIKit
import SnapKit

class BeerCell: UITableViewCell {
    
    static let reuseIdentifier = "beer_cell"
    
    private var controller: BeerCellController!
    private var beerId: Int?
    
    lazy var beerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()

    lazy var beerSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(addFavoritesTap), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        controller = BeerCellController(view: self)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(likeButton)
        contentView.addSubview(beerNameLabel)
        contentView.addSubview(beerSubtitleLabel)

        likeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.height.width.equalTo(44)
        }

        beerNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(likeButton.snp.left).offset(-12)
        }

        beerSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(beerNameLabel.snp.bottom).offset(4)
            make.left.equalTo(beerNameLabel)
            make.right.equalTo(beerNameLabel)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
        }
    }
    
    var onFavouriteToggled: (() -> Void)?

    @objc func addFavoritesTap() {
        guard let id = beerId else { return }
        controller.toggleFavourite(id: id)
        let isFav = controller.isFavourite(id: id)
        let icon = isFav ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: icon), for: .normal)
        onFavouriteToggled?()
    }
    
    func configure(with item: BeerListItem, isFavourite: Bool) {
        beerId = item.id
        beerNameLabel.text = item.name
        let abvText = item.abv.map { String(format: "ABV %.1f%%", $0) } ?? "ABV n/a"
        beerSubtitleLabel.text = "\(item.tagline) • \(abvText)"
        let icon = isFavourite ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: icon), for: .normal)
    }
}
