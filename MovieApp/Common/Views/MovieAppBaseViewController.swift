//
//  MovieAppBaseViewController.swift
//  MovieApp
//
//  Created by hayrı oguz on 24.10.2020.
//

import UIKit

class MovieAppBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func embedRightBarItem(icon: UIImage?) {
        let barItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(rightBarTapped(_:)))
        if self.navigationController?.isNavigationBarHidden ?? false {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    @objc func rightBarTapped(_ sender: UIBarButtonItem) {
        
    }
}


extension MovieAppBaseViewController {
    func showInfoPopup(message: String) {
         let alert = UIAlertController(title: NSLocalizedString("Info", comment: ""), message: message, preferredStyle: .alert)
         let done = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
         alert.addAction(done)
         self.present(alert, animated: true, completion: nil)
     }
     
     func showErrorPopup(message: String) {
          let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: message, preferredStyle: .alert)
          let done = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
          alert.addAction(done)
          self.present(alert, animated: true, completion: nil)
      }
}
