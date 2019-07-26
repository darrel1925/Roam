//
//  WendysMealSelectionViewController.swift
//  Roam
//
//  Created by Kay Lab on 5/21/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class WendysMealSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white
        
        //let x = CartButtonLauncher()
       // x.show(PandaVc: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 :
            return 1
        case 1 :
            return Wendys.Hamburgers.header.count
        case 2 :
            return 1
        case 3 :
            return Wendys.Chcicken.header.count
        case 4 :
            return 1
        case 5 :
            return Wendys.FreshMadeSalad.header.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section  = indexPath.section
        let row = indexPath.row
        
        if [0,2,4].contains(section) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell") as! TitleCell
            
            switch section {
                case 0:
                    cell.titleLabel.text = Wendys.Hamburgers.title
                case 2:
                    cell.titleLabel.text = Wendys.Chcicken.title
                case 4:
                    cell.titleLabel.text = Wendys.FreshMadeSalad.title
                default:
                    cell.titleLabel.text = "Error"
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDescriptionCell") as! ItemDescriptionCell
            switch section {
                case 1:
                    cell.headerLabel.text = Wendys.Hamburgers.header[row]
                    cell.descriptionLabel.text = Wendys.Hamburgers.description[row]
                    cell.priceLabel.text = "$" + String(format: "%.2f", Wendys.Hamburgers.price[row])
                case 3:
                    print(row)
                    cell.headerLabel.text = Wendys.Chcicken.header[row]
                    cell.descriptionLabel.text = Wendys.Chcicken.description[row]
                    cell.priceLabel.text = "$" + String(format: "%.2f", Wendys.Chcicken.price[row])
                case 5:
                    cell.headerLabel.text = Wendys.FreshMadeSalad.header[row]
                    cell.descriptionLabel.text = Wendys.FreshMadeSalad.description[row]
                    cell.priceLabel.text = "$" + String(format: "%.2f", Wendys.FreshMadeSalad.price[row])
                default:
                    cell.headerLabel.text = "Error"
                
            }
            return cell
        }
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
