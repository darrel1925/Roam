//
//  BlackBackgroundController.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/15/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class BlackBackgroundController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleDismiss() {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
}
