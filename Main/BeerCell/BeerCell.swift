//
//  BeerCell.swift
//  HopSpot
//
//  Created by ake11a on 2022-11-12.
//

import UIKit
import SnapKit
import RealmSwift

class BeerCell: UITableViewCell {
    
    private var controller: BeerCellController!
    private var didSetupViews = false
    
    let realm = try! Realm()
    
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
    
    lazy var likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart")
        imageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addFavoritesTap))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()

        guard !didSetupViews else { return }
        didSetupViews = true

        controller = BeerCellController(view: self)

        addSubview(likeImageView)
        addSubview(beerNameLabel)
        addSubview(beerSubtitleLabel)

        likeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.height.width.equalTo(50)
        }

        beerNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(likeImageView.snp.left).offset(-12)
        }

        beerSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(beerNameLabel.snp.bottom).offset(4)
            make.left.equalTo(beerNameLabel)
            make.right.equalTo(beerNameLabel)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
        }
    }
    
    @objc func addFavoritesTap() {
        controller.addFavourite(title: beerNameLabel.text!)
    }
}
