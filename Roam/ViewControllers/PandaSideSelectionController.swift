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
    
    var foodItem: String!
    var foodSize: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.separatorColor = .white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section  == 0 {
            print("hello")
            return 1
        }
        if foodSize == "Full" {
            print("Section: \(section) is \(foodSize) with \(numFullChoices()) rows")
            return numFullChoices()
        }
        else {
            print("Section: \(section) is: \(foodSize) with \(numHalfChoices()) rows")
            return numHalfChoices()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SideSelectionTitleCell") as! SideSelectionTitleCell
                if foodSize == "Half" {
                    switch foodItem {
                    case "Plate":
                        cell.headerLabel.text = PandaExpress.Plate.Selection.Half.header
                        cell.priceLabel.text = "$" + String(format: "%.2f", PandaExpress.Plate.price)
                        cell.descriptionLabel.text = PandaExpress.Plate.description[0]
                        return cell
                    case "Bigger Plate":
                        cell.headerLabel.text = PandaExpress.BiggerPlate.Selection.Half.header
                        cell.priceLabel.text = "$" + String(format: "%.2f", PandaExpress.BiggerPlate.price)
                        cell.descriptionLabel.text = PandaExpress.BiggerPlate.description[0]
                        return cell                    case "Bowl":
                        return cell
                    case "Family Feast":
                        cell.headerLabel.text = PandaExpress.FamilyFeast.Selection.Half.header
                        cell.priceLabel.text = "$" + String(format: "%.2f", PandaExpress.FamilyFeast.price)
                        cell.descriptionLabel.text = PandaExpress.FamilyFeast.description[0]
                        return cell
                    default:
                        let cellError = UITableViewCell()
                        cellError.textLabel?.text = "Error"
                        return cellError
                        
                    }
                } else {
                    switch foodItem {
                    case "Plate":
                        cell.headerLabel.text = PandaExpress.Plate.Selection.Full.header
                        cell.priceLabel.text = "$" + String(format: "%.2f", PandaExpress.Plate.price)
                        cell.descriptionLabel.text = PandaExpress.Plate.description[1]
                        return cell
                    case "Bigger Plate":
                        cell.headerLabel.text = PandaExpress.BiggerPlate.Selection.Full.header
                        cell.priceLabel.text = "$" + String(format: "%.2f", PandaExpress.BiggerPlate.price)
                        cell.descriptionLabel.text = PandaExpress.BiggerPlate.description[1]
                        return cell                    case "Bowl":
                            return cell
                    case "Family Feast":
                        cell.headerLabel.text = PandaExpress.FamilyFeast.Selection.Full.header
                        cell.priceLabel.text = "$" + String(format: "%.2f", PandaExpress.FamilyFeast.price)
                        cell.descriptionLabel.text = PandaExpress.FamilyFeast.description[1]
                        return cell
                    default:
                        let cellError = UITableViewCell()
                        cellError.textLabel?.text = "Error"
                        return cellError
                    }
                }

            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SideOptionCell") as! SideOptionCell
                if foodSize == "Half" {
                    switch foodItem {
                    case "Plate":
                        cell.headerLabel.text = PandaExpress.Plate.Selection.Half.choices[row]
                        cell.selectedItemLabel.text = PandaExpress.SideOption.Half.name[0]
                        return cell
                    case "Bigger Plate":
                        cell.headerLabel.text = PandaExpress.BiggerPlate.Selection.Half.choices[row]
                        cell.selectedItemLabel.text = PandaExpress.SideOption.Half.name[0]
                        return cell
                    case "Bowl":
                        cell.headerLabel.text = PandaExpress.Bowl.Selection.Half.choices[row]
                        cell.selectedItemLabel.text = PandaExpress.SideOption.Half.name[0]
                        return cell
                    case "Family Feast":
                        cell.headerLabel.text = PandaExpress.FamilyFeast.Selection.Half.choices[row]
                        cell.selectedItemLabel.text = PandaExpress.SideOption.Half.name[0]
                        return cell
                    default:
                        let cellError = UITableViewCell()
                        cellError.textLabel?.text = "Error"
                        return cellError
                    }
                } else {
                    switch foodItem {
                    case "Plate":
                        cell.headerLabel.text = PandaExpress.Plate.Selection.Full.choices[row]
                        cell.selectedItemLabel.text = PandaExpress.SideOption.Full.name[0]
                        return cell
                    case "Bigger Plate":
                        cell.headerLabel.text = PandaExpress.BiggerPlate.Selection.Full.choices[row]
                        cell.selectedItemLabel.text = PandaExpress.SideOption.Full.name[0]
                        return cell
                    case "Bowl":
                        cell.headerLabel.text = PandaExpress.Bowl.Selection.Full.choices[row]
                        cell.selectedItemLabel.text = PandaExpress.SideOption.Full.name[0]
                        return cell
                    case "Family Feast":
                        cell.headerLabel.text = PandaExpress.FamilyFeast.Selection.Full.choices[row]
                        cell.selectedItemLabel.text = PandaExpress.SideOption.Full.name[0]
                        return cell
                    default:
                        let cellError = UITableViewCell()
                        cellError.textLabel?.text = "Error"
                        return cellError
                    }
                }
            default:
                let cellError = UITableViewCell()
                cellError.textLabel?.text = "Error"
                return cellError
        }
    }
    
    @IBAction func showMenu(_ sender: Any) {
        settingsLauncher.showSettings()
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func numFullChoices() -> Int {
        switch foodItem {
        case "Plate":
            return PandaExpress.Plate.Selection.Full.choices.count
        case "Bigger Plate":
            return PandaExpress.BiggerPlate.Selection.Full.choices.count
        case "Bowl":
            return PandaExpress.Bowl.Selection.Full.choices.count
        case "Family Feast":
            return PandaExpress.FamilyFeast.Selection.Full.choices.count
        default:
            return 0
        }
    }
    
    func numHalfChoices() -> Int {
        switch foodItem {
        case "Plate":
            return PandaExpress.Plate.Selection.Half.choices.count
        case "Bigger Plate":
            return PandaExpress.BiggerPlate.Selection.Half.choices.count
        case "Bowl":
            return PandaExpress.Bowl.Selection.Half.choices.count
        case "Family Feast":
            return PandaExpress.FamilyFeast.Selection.Half.choices.count
        default:
            return 0
        }
    }
}
