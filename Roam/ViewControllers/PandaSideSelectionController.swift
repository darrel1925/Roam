//
//  PandaSideSelectionController.swift
//  Roam
//
//  Created by Kay Lab on 5/21/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class PandaSideSelectionController: UIViewController {
    
    @IBOutlet weak var menuBar: UINavigationBar!
    
    let settingsLauncher = SettingsLauncher()
    let blackView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    
    @IBAction func showMenu(_ sender: Any) {
        
        settingsLauncher.showSettings()
        
    }
    
}
