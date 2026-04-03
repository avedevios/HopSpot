//
//  ExtensionsUIViewController.swift
//  lesson5412
//
//  Created by ake11a on 2022-11-20.
//

import UIKit

extension UIViewController {
    func createFavoritesBarButton(image: String, selector: Selector) -> UIBarButtonItem {
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.image = UIImage(systemName: image)
        imageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: selector)
        imageView.addGestureRecognizer(tap)
        
        let barItem = UIBarButtonItem(customView: imageView)
        return barItem
    }
}
