//
//  BeerCell.swift
//  lesson5412
//
//  Created by ake11a on 2022-11-12.
//

import UIKit
import SnapKit
import RealmSwift

class BeerCell: UITableViewCell {
    
    private var controller: BeerCellController!
    
    let realm = try! Realm()
    
    lazy var beerImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    lazy var beerNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "suit.heart")
        imageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addFavoritesTap))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        controller = BeerCellController(view: self)
        
        backgroundColor = .orange
        
        addSubview(beerImageView)
        beerImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(30)
            make.height.equalTo(50)
        }
        
        addSubview(likeImageView)
        likeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            //make.left.equalTo(beerNameLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        addSubview(beerNameLabel)
        beerNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(beerImageView.snp.right).offset(10)
            make.right.equalTo(likeImageView.snp.left).offset(-10)
        }
    }
    
    @objc func addFavoritesTap() {
        if controller.addFavourite(title: beerNameLabel.text!) {
            likeImageView.image = UIImage(systemName: "suit.heart.fill")
        } else {
            likeImageView.image = UIImage(systemName: "suit.heart")
        }
    }
}

