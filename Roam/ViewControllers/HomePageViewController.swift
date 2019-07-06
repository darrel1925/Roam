//
//  HomePageViewController.swift
//  Roam
//
//  Created by Kay Lab on 5/18/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var toShoppinCart: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toShoppinCart.layer.cornerRadius = 20
        showShoppingCart()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    func showShoppingCart() {
        // if there is an order show this button
        
        // else hide this button
        toShoppinCart.alpha = 0
    }
}
