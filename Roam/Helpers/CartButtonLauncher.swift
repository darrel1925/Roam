//
//  CartButtonLauncher.swift
//  Roam
//
//  Created by Darrel Muonekwu on 7/6/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class CartButtonLauncher: NSObject {
    
    let button = UIButton.init(type: .roundedRect)
    
    func show(PandaVc: UIViewController) {
        
            print("hi")
            button.frame = CGRect(x: 50.0, y: 150.0, width: 200.0, height: 52.0)
            button.setTitle("Please Work", for: .normal)
        button.backgroundColor = .black
        PandaVc.view.addSubview(button)
        button.addTarget(self, action: #selector(handleDismis(_:)), for: .touchUpInside)
        }
    
    @objc func handleDismis(_: UIButton) {
        print("worked")
    }
    
    override init() {
        super.init()
    }
}

