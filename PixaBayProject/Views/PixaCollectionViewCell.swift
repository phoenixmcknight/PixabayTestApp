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
    
    
    public func cellLabelAnimation() {
        UIView.transition(with: userName, duration: 1.5, options: [.autoreverse,.repeat], animations: {
            let alpha = self.userName.alpha > 0.3 ? 0.3 : 1
            self.userName.alpha = CGFloat(alpha)
        }, completion: nil)
        
    }
    
    private func cancelCellAnimation() {
        userName.layer.removeAllAnimations()
        userName.alpha = 1
    }
    
    public func setUpCell(hit:Hit) {
        
        pixaActivityIndc.startAnimating()
        
        guard let imageURL = hit.largeImageURL else {
            pixaActivityIndc.stopAnimating()
            pixaImageView.image = UIImage(systemName: "photo.fill")
            
            userName.text = "Unable To Load Image"
            userName.layer.removeAllAnimations()
            return
        }
        
        
        if let image = ImageHelper.shared.image(forKey: imageURL as NSString) {
            pixaImageView.image = image
            
            self.userName.text = hit.user ?? "Username Unavailable"
           cancelCellAnimation()
            
            pixaActivityIndc.stopAnimating()
        } else {
            
            ImageHelper.shared.getImage(urlStr: imageURL) { [weak self] (result) in
                DispatchQueue.main.async {
                    
                    switch result {
                    case .failure:
                        self?.pixaImageView.image = UIImage(systemName: "photo.fill")
                        self?.userName.text = "Unable To Load Image"
                        self?.cancelCellAnimation()
                        self?.pixaActivityIndc.stopAnimating()
                    case .success(let image):
                        
                        self?.pixaImageView.image = image
                        
                        self?.userName.text = hit.user ?? "Username Unavailable"
                        self?.cancelCellAnimation()

                        self?.pixaActivityIndc.stopAnimating()
                    }
                }
            }
        }
    }
}
