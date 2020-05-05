//
//  Extension.swift
//  PixaBayProject
//
//  Created by Phoenix McKnight on 5/4/20.
//  Copyright © 2020 Phoenix McKnight. All rights reserved.
//

import UIKit

extension ViewController {
    public func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message:message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancel)
        present(alertController,animated: true)
    }
}

extension UISearchBar {
    func hideSmallXCancelButton() {
        self.searchTextField.clearButtonMode = .never
    }
}

