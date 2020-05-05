//
//  DetailViewController.swift
//  PixaBayProject
//
//  Created by Phoenix McKnight on 5/4/20.
//  Copyright © 2020 Phoenix McKnight. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var pixaImage:UIImage!
    
    var currentHit:Hit!
    
   
    @IBOutlet weak var detailLabel: UILabel!
    
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    @IBOutlet weak var viewLabel: UILabel!
  
    
    @IBOutlet weak var tagLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        detailLabel.adjustsFontSizeToFitWidth = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        giveOutletsValues()
    }

    private func giveOutletsValues() {
        self.detailImageView.image = self.pixaImage
                  self.detailLabel.text = self.currentHit.user
                  self.viewLabel.text = "Views: \(self.currentHit.views ?? 0)"
                  self.tagLabel.text = "Tags: \(self.currentHit.tags ?? "Tags Unavailable")"
        UIView.animate(withDuration: 0.5, animations: {
             self.detailImageView.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.25) {
                self.detailLabel.alpha = 1
                self.tagLabel.alpha = 1
                self.viewLabel.alpha = 1
            }
               
        }
}
}
