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
    @IBOutlet weak var numOrdersLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var fadeButton: UIButton!
    @IBOutlet weak var orderTableView: UITableView!
    //  @IBOutlet var orderTableView: UITableView!
    
    var settingsLauncher : SettingsLauncher!
    let blackView = UIView()
    
    var itemName: String!
    var foodItem: String!
    var foodSize: String!
    var numOrders = 1.0
    var totalPrice: Double!
    var originalPrice: Double!
    var foodDescription: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalPrice = totalPrice
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setUpButtons()
    }
    
    
    /********************************************************/
    /***************** TABLE VIEW FUNCTIONS *****************/
    /********************************************************/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section  == 0 {
            print("hello")
            return 1
        }
        
        return getNumRows()
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
                        self.itemName = PandaExpress.Plate.Selection.Half.header
                        cell.headerLabel.text = PandaExpress.Plate.Selection.Half.header
                        cell.priceLabel.text = "$" + String(format: "%.2f", PandaExpress.Plate.price)
                        cell.descriptionLabel.text = PandaExpress.Plate.description[0]
                        return cell
                    case "Bigger Plate":
                        self.itemName = PandaExpress.BiggerPlate.Selection.Half.header
                        cell.headerLabel.text = PandaExpress.BiggerPlate.Selection.Half.header
                        cell.priceLabel.text = "$" + String(format: "%.2f", PandaExpress.BiggerPlate.price)
                        cell.descriptionLabel.text = PandaExpress.BiggerPlate.description[0]
                        return cell
                    case "Bowl":
                        self.itemName = PandaExpress.Bowl.Selection.Half.header
                        cell.headerLabel.text = PandaExpress.Bowl.Selection.Half.header
                        cell.priceLabel.text = "$" + String(format: "%.2f", PandaExpress.Bowl.price)
                        cell.descriptionLabel.text = PandaExpress.Bowl.description[0]
                        return cell
                    case "Family Feast":
                        self.itemName = PandaExpress.FamilyFeast.Selection.Half.header
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
                        self.itemName = PandaExpress.Plate.Selection.Full.header

                        cell.headerLabel.text = PandaExpress.Plate.Selection.Full.header
                        cell.priceLabel.text = "$" + String(format: "%.2f", PandaExpress.Plate.price)
                        cell.descriptionLabel.text = PandaExpress.Plate.description[1]
                        return cell
                    case "Bigger Plate":
                        self.itemName = PandaExpress.BiggerPlate.Selection.Full.header
                        cell.headerLabel.text = PandaExpress.BiggerPlate.Selection.Full.header
                        cell.priceLabel.text = "$" + String(format: "%.2f", PandaExpress.BiggerPlate.price)
                        cell.descriptionLabel.text = PandaExpress.BiggerPlate.description[1]
                        return cell
                    case "Bowl":
                        self.itemName = PandaExpress.Bowl.Selection.Full.header
                        cell.headerLabel.text = PandaExpress.Bowl.Selection.Full.header
                        cell.priceLabel.text = "$" + String(format: "%.2f", PandaExpress.Bowl.price)
                        cell.descriptionLabel.text = PandaExpress.Bowl.description[1]
                        return cell
                    case "Family Feast":
                        self.itemName = PandaExpress.FamilyFeast.Selection.Full.header
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
                        cell.selectedItemLabel.text = PandaExpress.SideOption.Half.name[0] + " + $0.00"
                        return cell
                    case "Bigger Plate":
                        cell.headerLabel.text = PandaExpress.BiggerPlate.Selection.Half.choices[row]
                        cell.selectedItemLabel.text = PandaExpress.SideOption.Half.name[0] + " + $0.00"
                        return cell
                    case "Bowl":
                        cell.headerLabel.text = PandaExpress.Bowl.Selection.Half.choices[row]
                        cell.selectedItemLabel.text = PandaExpress.SideOption.Half.name[0] + " + $0.00"
                        return cell
                    case "Family Feast":
                        cell.headerLabel.text = PandaExpress.FamilyFeast.Selection.Half.choices[row]
                        cell.selectedItemLabel.text = PandaExpress.SideOption.Half.name[0] + " + $0.00"
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
                        cell.selectedItemLabel.text = PandaExpress.SideOption.Full.name[0] + " + $0.00"
                        return cell
                    case "Bigger Plate":
                        cell.headerLabel.text = PandaExpress.BiggerPlate.Selection.Full.choices[row]
                        cell.selectedItemLabel.text = PandaExpress.SideOption.Full.name[0] + " + $0.00"
                        return cell
                    case "Bowl":
                        cell.headerLabel.text = PandaExpress.Bowl.Selection.Full.choices[row]
                        cell.selectedItemLabel.text = PandaExpress.SideOption.Full.name[0] + " + $0.00"
                        return cell
                    case "Family Feast":
                        cell.headerLabel.text = PandaExpress.FamilyFeast.Selection.Full.choices[row]
                        cell.selectedItemLabel.text = PandaExpress.SideOption.Full.name[0] + " + $0.00"
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // your not clicking on the title
        if indexPath.section == 1 {
            settingsLauncher = SettingsLauncher()
            settingsLauncher.showSettings(indexPathClicked: indexPath, PandaVC: self)
        }
    }
    
    /********************************************************/
    /******************* HELPER FUNCTIONS *******************/
    /********************************************************/
    
    func getNumRows() -> Int {
        if foodSize == "Full" {
            print("Section: \(1) is \(String(describing: foodSize)) with \(numFullChoices()) rows")
            return numFullChoices()
        }
        else {
            print("Section: \(1) is: \(String(describing: foodSize)) with \(numHalfChoices()) rows")
            return numHalfChoices()
        }
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
    
    func fadeTotalAmtButton() {
        fadeButton.alpha = 1
        
        UIView.animate(withDuration: 0.5) {
            self.fadeButton.alpha = 0.1
        }
    }
    
    func addToOrder() {
        let totalAsDouble = Double(totalPrice)
        let product = Product(name: itemName!, price: totalAsDouble , amountOrdered: Int(numOrders), description: foodDescription!)
        
        StripeCart.addItemToCart(item: product)
        
        dismiss(animated: true, completion: nil)
    }

    // to update the total price var in PandaSideSelectionVC
    func getOrderDetails() {
        foodDescription = ""
        var total = 0.0
        for row in 0..<getNumRows() {
            let indexPath = IndexPath(row: row, section: 1)
            let cell = tableView.cellForRow(at: indexPath) as! SideOptionCell
            let itemArr = cell.selectedItemLabel.text!.components(separatedBy: " + $")
            
            foodDescription += itemArr[0] + ", "
            total += Double(itemArr[1])!
        }
        totalPrice = total + originalPrice
        totalPriceLabel.text = "ADD $" + String(format: "%.2f", totalPrice * numOrders)
    }
    
    func setUpButtons() {
        //tableView.separatorColor = .white
        
        totalPriceLabel.layer.masksToBounds = true
        totalPriceLabel.text = "ADD $" + String(format: "%.2f", totalPrice)
        
        numOrdersLabel.text = "1"
        numOrdersLabel.layer.masksToBounds = true
        
        fadeButton.layer.masksToBounds = true
    }
    
    /********************************************************/
    /******************* ACTION FUNCTIONS *******************/
    /********************************************************/
    
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onPlusButton(_ sender: Any) {
        numOrders += 1
        
        numOrdersLabel.text = "\(Int(numOrders))"
        totalPriceLabel.text = "ADD $" + String(format: "%.2f", totalPrice * numOrders)
        
        fadeButton.backgroundColor = .black
        fadeTotalAmtButton()
    }
    
    @IBAction func onMinusButton(_ sender: Any) {
        if numOrders > 1 {
            numOrders -= 1
            
            numOrdersLabel.text = "\(Int(numOrders))"
            totalPriceLabel.text = "ADD $" + String(format: "%.2f", totalPrice * numOrders)
            
            fadeTotalAmtButton()
        }
    }
    
    @IBAction func addToCart(_ sender: Any) {
        getOrderDetails()
        addToOrder()
        fadeTotalAmtButton()
    }
}
