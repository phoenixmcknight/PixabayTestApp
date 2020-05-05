//
//  PixaCollectionViewCell.swift
//  PixaBayProject
//
//  Created by Phoenix McKnight on 5/4/20.
//  Copyright © 2020 Phoenix McKnight. All rights reserved.
//

import UIKit

class PixaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pixaImageView: UIImageView!
    
    
    @IBOutlet weak var pixaActivityIndc: UIActivityIndicatorView!
    
    @IBOutlet weak var userName: UILabel!
    
    public func setUpCell(hit:Hit) {
        
        pixaActivityIndc.startAnimating()
        
        guard let imageURL = hit.largeImageURL else {
            pixaActivityIndc.stopAnimating()
            pixaImageView.image = UIImage(systemName: "photo.fill")
            
            userName.text = "Unable To Load Image"
            return
        }
        
        
        if let image = ImageHelper.shared.image(forKey: imageURL as NSString) {
            pixaImageView.image = image
            
            self.userName.text = hit.user ?? "Username Unavailable"
            pixaActivityIndc.stopAnimating()
        } else {
            
            ImageHelper.shared.getImage(urlStr: imageURL) { [weak self] (result) in
                DispatchQueue.main.async {
                    
                    switch result {
                    case .failure:
                        self?.pixaImageView.image = UIImage(systemName: "photo.fill")
                        self?.userName.text = "Unable To Load Image"
                        self?.pixaActivityIndc.stopAnimating()
                    case .success(let image):
                        
                        self?.pixaImageView.image = image
                        
                        self?.userName.text = hit.user ?? "Username Unavailable"
                        self?.pixaActivityIndc.stopAnimating()
                    }
                }
            }
        }
    }
}
