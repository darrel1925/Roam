//
//  PandaMealSelectionController.swift
//  Roam
//
//  Created by Kay Lab on 5/18/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class PandaMealSelectionController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if [0,2,4,6].contains(section) {
            print("even section: \(section)")
            return 1
        }
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section  = indexPath.section
        let row = indexPath.row
        
        if [0,2,4,6].contains(section) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell") as! TitleCell
            
            switch section {
                case 0:
                    cell.titleLabel.text = PandaExpress.Plate.title
                case 2:
                    cell.titleLabel.text = PandaExpress.BiggerPlate.title
                case 4:
                    cell.titleLabel.text = PandaExpress.Bowl.title
                case 6:
                    cell.titleLabel.text = PandaExpress.FamilyFeast.title
                default:
                    cell.titleLabel.text = "Error"
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDescriptionCell") as! ItemDescriptionCell
            
            switch section {
                case 1:
                    cell.headerLabel.text = PandaExpress.Plate.header[row]
                    cell.descriptionLabel.text = PandaExpress.Plate.description[row]
                    cell.priceLabel.text = "$" + String(format: "%.2f", PandaExpress.Plate.price)
                case 3:
                    cell.headerLabel.text = PandaExpress.BiggerPlate.header[row]
                    cell.descriptionLabel.text = PandaExpress.BiggerPlate.description[row]
                    cell.priceLabel.text = "$\(PandaExpress.BiggerPlate.price)"
                case 5:
                    cell.headerLabel.text = PandaExpress.Bowl.header[row]
                    cell.descriptionLabel.text = PandaExpress.Bowl.description[row]
                    cell.priceLabel.text = "$\(PandaExpress.Bowl.price)"
                case 7:
                    cell.headerLabel.text = PandaExpress.FamilyFeast.header[row]
                    cell.descriptionLabel.text = PandaExpress.FamilyFeast.description[row]
                    cell.priceLabel.text = "$\(PandaExpress.FamilyFeast.price)"
                default:
                    cell.headerLabel.text = "Error"
                
            }
            return cell
        }
    }
    

}
