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
        self.navigationController!.navigationBar.tintColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)

        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // TODO: figure out a way to know what food item i am customizing on the next screen
            // i might need to make differnt View controllers
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let section = indexPath.section
        let row = indexPath.row
        
        let PandaSideSelectionVC = segue.destination as! PandaSideSelectionController
        
        switch section {
            case 1:
                PandaSideSelectionVC.foodItem  = "Plate"
            case 3:
                PandaSideSelectionVC.foodItem = "Bigger Plate"
            case 5:
                PandaSideSelectionVC.foodItem = "Bowl"
            default:
                PandaSideSelectionVC.foodItem = "Family Feast"
        }
        
        switch row {
            case 0:
                PandaSideSelectionVC.foodSize  = "Half"
            case 1:
                PandaSideSelectionVC.foodSize = "Full"
            default:
                PandaSideSelectionVC.foodSize = "Food size cannot be determined"
        }
        
        
        print("Prepared")
    }
    
}
