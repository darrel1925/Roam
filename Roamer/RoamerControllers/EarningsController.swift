//
//  EarningsController.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/1/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class EarningsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 4
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EarningsCell") as! EarningsCell
            cell.titleLabel.text = "Current Week"
            cell.moneyEarnedLabel.text = "$26.35"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EarningsTitleCell") as! EarningsTitleCell
            cell.dateLabel.text = "August 2019"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EarningsDetailCell") as! EarningsDetailCell
            cell.datesLabel.text = "April 23 - April 30"
            cell.moneyEarnedLabel.text = "$128.44"
            return cell
        default:
            let cell = UITableViewCell()
            cell.textLabel?.text = "error"
        }
        return UITableViewCell()
    }
    
    
}
