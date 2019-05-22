//
//  PandaSideSelectionController.swift
//  Roam
//
//  Created by Kay Lab on 5/21/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class PandaSideSelectionController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    let settingsLauncher = SettingsLauncher()
    let blackView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            default:
                return 2
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        switch section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
                return cell!
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
                return cell!
        }
        
    }
    
    @IBAction func showMenu(_ sender: Any) {
        settingsLauncher.showSettings()
    }
    
}
