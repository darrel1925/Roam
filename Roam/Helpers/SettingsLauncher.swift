//
//  File.swift
//  Roam
//
//  Created by Kay Lab on 5/21/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit


class SettingsLauncher: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var button: UIButton!
    let blackView = UIView()
    var mainTableView: UITableView!
    var tableView: UITableView!
    var foodItem: String!
    var foodSize: String!
    var indexPathClicked: IndexPath!
    
    var chosenFoodName: String!
    var chosenFoodPrice: String!

    func showSettings(tableView: UITableView, mainTableView: UITableView, foodSize: String, foodItem: String, indexPathClicked: IndexPath) {
        
        self.foodSize = foodSize
        self.foodItem = foodItem
        self.indexPathClicked = indexPathClicked
        self.mainTableView = mainTableView
        
        self.tableView = tableView
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.alpha = 1
        
        // entire applications window
        if let window = UIApplication.shared.keyWindow {
            // 0 = black  |  alpha = transpancy
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
        // create the continue button
        self.button = UIButton(frame: CGRect(x: window.center.x, y: window.frame.height, width: window.frame.width * 0.8, height: 43))
            
            // add blackView, tableView, and button to the screen
            
            window.addSubview(blackView)
            window.addSubview(tableView)
            window.addSubview(button)
            
            // format the size of black background
            blackView.frame = window.frame
            blackView.alpha = 0
            
            // format button
            button.backgroundColor = .black
            button.setTitle("Continue", for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            button.center.x = blackView.center.x
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
            button.layer.cornerRadius = 20

            // format size of the tableView
            let height: CGFloat = window.frame.height * 0.66
            let y = window.frame.height - height
                // window.frame.height is the bottom of the window aka the bottom of the screen
            tableView.frame = CGRect(x: 0, y: window.frame.height , width: window.frame.width, height: height)
            
            // this animation accelerates the animation fast in the begining and slower towards the end of the animation
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha  = 1
                self.tableView.frame =  CGRect(x: 0, y: y, width: self.tableView.frame.width, height: self.tableView.frame.height)
                self.button.frame =  CGRect(x: self.blackView.frame.midX , y: self.blackView.frame.height * 0.9, width: window.frame.width * 0.8, height: 43)
                self.button.center.x = self.blackView.frame.midX

                
            }, completion: nil)
            
            // add Tap Gesture to dismiss the everything
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        }
    }
    
    @objc func handleDismiss() {
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                
                self.tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height)
                self.button.frame = CGRect(x: self.blackView.frame.midX , y: window.frame.height, width: window.frame.width * 0.8, height: 43)
                self.button.center.x = self.blackView.frame.midX

            }
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        
        if chosenFoodPrice != nil {
            let cell = mainTableView.cellForRow(at: self.indexPathClicked) as! SideOptionCell
            
            cell.selectedItemLabel.text = chosenFoodName + " + " + chosenFoodPrice
            
            handleDismiss()
        } else {
            // TODO: Notify user to choose an option
        }
    }
    
    func dismissWindow() {
        
    }
    
    /********************************************************/
    /***************** TABLE VIEW FUNCTIONS *****************/
    /********************************************************/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return numEntreesOrSides()
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EntreeTitleCell") as! EntreeTitleCell
            cell.titleLabel.text = titleSelection()[self.indexPathClicked.row]
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseEntreeCell") as! ChooseEntreeCell
            cell.checkView.image = UIImage(named: "empty")
            if entreesOrSides() == "Side" {
                if foodSize == "Half" {
                    print("Side | Half")
                    cell.entreeLabel.text = PandaExpress.SideOption.Half.name[row]
                    cell.priceLabel.text = "+ $" + String(format: "%.2f", PandaExpress.SideOption.Half.price[row])
                    return cell
                }
                // they clicked on a Full side
                else {
                    print("Side | Full")
                    cell.entreeLabel.text = PandaExpress.SideOption.Full.name[row]
                    cell.priceLabel.text = "+ $" + String(format: "%.2f", PandaExpress.SideOption.Full.price[row])
                    return cell
                }
            }
            // they clicked on an entree
            else {
                print("Entree | Entree")
                cell.entreeLabel.text = PandaExpress.EntreeOption.name[row]
                cell.priceLabel.text = "+ $" + String(format: "%.2f", PandaExpress.EntreeOption.price[row])
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            tableView.reloadData()
            let cell = tableView.cellForRow(at: indexPath) as! ChooseEntreeCell
            cell.checkView.image = UIImage(named: "check")
        }
        
        // vaiables to change labels on PandaExpressSideSelection
        let cell = tableView.cellForRow(at: indexPath) as! ChooseEntreeCell
        
        // formats price to a '$0.00'
        self.chosenFoodPrice = cell.priceLabel.text
        let index = self.chosenFoodPrice.index(self.chosenFoodPrice.endIndex, offsetBy: -5)
        let mySubstring = self.chosenFoodPrice[index...] // playground
        
        self.chosenFoodPrice = String(mySubstring)
        self.chosenFoodName = cell.entreeLabel.text

        //self.chosenFoodPrice.remove(at: self.chosenFoodPrice.startIndex)
    }
    
    
    /***************************************************************/
    /***************** TABLE VIEW HELPER FUNCTIONS *****************/
    /***************************************************************/
    
    func numEntreesOrSides() -> Int {
        switch foodSize
        {
            case "Full":
                if self.foodItem == "Plate"
                {
                    if self.indexPathClicked.row <= 0
                    {
                        return PandaExpress.SideOption.Full.name.count
                    }
                    else
                    {
                        return PandaExpress.EntreeOption.name.count
                    }
                }
                else if foodItem == "Bigger Plate"
                {
                    if self.indexPathClicked.row <= 0
                    {
                        return PandaExpress.SideOption.Full.name.count
                    }
                    else
                    {
                        return PandaExpress.EntreeOption.name.count
                    }
                }
                else if foodItem == "Bowl"
                {
                    if self.indexPathClicked.row <= 0
                    {
                        return PandaExpress.SideOption.Full.name.count
                    }
                    else
                    {
                        return PandaExpress.EntreeOption.name.count
                    }
                }
                else if foodItem == "Family Feast"
                {
                    if self.indexPathClicked.row <= 1
                    {
                        return PandaExpress.SideOption.Full.name.count
                    }
                    else
                    {
                        return PandaExpress.EntreeOption.name.count
                    }
                }
            case "Half":
                if self.foodItem == "Plate"
                {
                    if self.indexPathClicked.row <= 1
                    {
                        return PandaExpress.SideOption.Full.name.count
                    }
                    else
                    {
                        return PandaExpress.EntreeOption.name.count
                    }
                }
                else if foodItem == "Bigger Plate"
                {
                    if self.indexPathClicked.row <= 1
                    {
                        return PandaExpress.SideOption.Full.name.count
                    }
                    else
                    {
                        return PandaExpress.EntreeOption.name.count
                    }
                }
                else if foodItem == "Bowl"
                {
                    if self.indexPathClicked.row <= 1
                    {
                        return PandaExpress.SideOption.Full.name.count
                    }
                    else
                    {
                        return PandaExpress.EntreeOption.name.count
                    }
                }
                else if foodItem == "Family Feast"
                {
                    if self.indexPathClicked.row <= 2
                    {
                        return PandaExpress.SideOption.Full.name.count
                    }
                    else
                    {
                        return PandaExpress.EntreeOption.name.count
                    }
                }
            default:
                return 0
        }
    return 0
    }
    
    func entreesOrSides() -> String {
        switch foodSize
        {
        case "Full":
            if self.foodItem == "Plate"
            {
                if self.indexPathClicked.row <= 0
                {
                    return "Side"
                }
                else
                {
                    return "Entree"
                }
            }
            else if foodItem == "Bigger Plate"
            {
                if self.indexPathClicked.row <= 0
                {
                    return "Side"
                    
                }
                else
                {
                    return "Entree"
                    
                }
            }
            else if foodItem == "Bowl"
            {
                if self.indexPathClicked.row <= 0
                {
                    return "Side"
                }
                else
                {
                    return "Entree"
                    
                }
            }
            else if foodItem == "Family Feast"
            {
                if self.indexPathClicked.row <= 1
                {
                    return "Side"
                    
                }
                else
                {
                    return "Entree"
                    
                }
            }
        case "Half":
            if self.foodItem == "Plate"
            {
                if self.indexPathClicked.row <= 1
                {
                    return "Side"
                    
                }
                else
                {
                    return "Entree"
                    
                }
            }
            else if foodItem == "Bigger Plate"
            {
                if self.indexPathClicked.row <= 1
                {
                    return "Side"
                    
                }
                else
                {
                    return "Entree"
                    
                }
            }
            else if foodItem == "Bowl"
            {
                if self.indexPathClicked.row <= 1
                {
                    return "Side"
                    
                }
                else
                {
                    return "Entree"
                    
                }
            }
            else if foodItem == "Family Feast"
            {
                if self.indexPathClicked.row <= 2
                {
                    return "Side"
                    
                }
                else
                {
                    return "Entree"
                    
                }
            }
        default:
            return ""
        }
        return ""
    }
    
    func titleSelection() -> [String] {
        switch foodSize
        {
        case "Full":
            if self.foodItem == "Plate"
            {
                 return  PandaExpress.Plate.Selection.Full.choices
            }
            else if foodItem == "Bigger Plate"
            {
                return PandaExpress.BiggerPlate.Selection.Full.choices
            }
            else if foodItem == "Bowl"
            {
                return PandaExpress.Bowl.Selection.Full.choices
            }
            else if foodItem == "Family Feast"
            {
                return PandaExpress.FamilyFeast.Selection.Full.choices
            }
        case "Half":
            if self.foodItem == "Plate"
            {
                return  PandaExpress.Plate.Selection.Half.choices
            }
            else if foodItem == "Bigger Plate"
            {
                return PandaExpress.BiggerPlate.Selection.Half.choices
            }
            else if foodItem == "Bowl"
            {
                return PandaExpress.Bowl.Selection.Half.choices
            }
            else if foodItem == "Family Feast"
            {
                return PandaExpress.FamilyFeast.Selection.Half.choices
            }
        default:
            return [""]
        }
        return [""]
        
    }
    
    override init() {
        super.init()
        // start doing something here maybe
    }
}
