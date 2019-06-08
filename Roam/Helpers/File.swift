//
//  File.swift
//  Roam
//
//  Created by Kay Lab on 5/21/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit


class SettingsLauncher: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    let blackView = UIView()
    var tableView: UITableView!
    var foodItem: String!
    var foodSize: String!
    var rowClicked: Int!

    func showSettings(tableView: UITableView, foodSize: String, foodItem: String, rowClicked: Int) {
        
        print("Food size is: \(foodSize), food item is: \(foodItem)" )
        self.foodSize = foodSize
        self.foodItem = foodItem
        self.rowClicked = rowClicked
        
        self.tableView = tableView
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // entire applications window
        if let window = UIApplication.shared.keyWindow {
            // 0 = black  |  alpha = transpancy
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            // add blackView and tableView to the screen
            window.addSubview(blackView)
            window.addSubview(tableView)
            
            // format the size of black background
            blackView.frame = window.frame
            blackView.alpha = 0
            
            // format size of the tableView
            let height: CGFloat = 600
            let y = window.frame.height - height
                // window.frame.height is the bottom of the window aka the bottom of the screen
            tableView.frame = CGRect(x: 0, y: window.frame.height , width: window.frame.width, height: height)
            
            // this animation accelerates the animation fast in the begining and slower towards the end
                // of the animation
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha  = 1
                self.tableView.frame =  CGRect(x: 0, y: y, width: self.tableView.frame.width, height: self.tableView.frame.height)
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
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            print("num rows in section is: \(numEntreesOrSides())")
            return numEntreesOrSides()
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EntreeTitleCell") as! EntreeTitleCell
            cell.titleLabel.text = self.foodItem
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseEntreeCell") as! ChooseEntreeCell
            if entreesOrSides() == "Side" {
                if foodSize == "Half" {
                    print("Side | Half")
                    cell.entreeLabel.text = PandaExpress.SideOption.Half.name[row]
                    cell.priceLabel.text = "$ \(PandaExpress.SideOption.Half.price[row])"
                    return cell
                }
                // they clicked on a Full side
                else {
                    print("Side | Full")
                    cell.entreeLabel.text = PandaExpress.SideOption.Full.name[row]
                    cell.priceLabel.text = "$ \(PandaExpress.SideOption.Full.price[row])"
                    return cell
                }
            }
            // they clicked on an entree
            else {
                print("Entree | Entree")
                cell.entreeLabel.text = PandaExpress.EntreeOption.name[row]
                cell.priceLabel.text = "$ \(PandaExpress.EntreeOption.price[row])"
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    
    func numSideOptions() -> Int {
        switch self.foodSize {
        case "Half":
            return PandaExpress.SideOption.Half.name.count
        case "Full":
            return PandaExpress.SideOption.Full.name.count
        default:
            return 0
        }
    }
    
    func numEntreeOptions() -> Int {
        return PandaExpress.EntreeOption.name.count
    }
    
    func numEntreesOrSides() -> Int {
        print("rowClicked: \(self.rowClicked)")
        switch foodSize
        {
            case "Full":
                if self.foodItem == "Plate"
                {
                    if self.rowClicked <= 0
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
                    if self.rowClicked <= 0
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
                    if self.rowClicked <= 0
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
                    if self.rowClicked <= 1
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
                    if self.rowClicked <= 1
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
                    if self.rowClicked <= 1
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
                    if self.rowClicked <= 1
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
                    if self.rowClicked <= 2
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
                if self.rowClicked <= 0
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
                if self.rowClicked <= 0
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
                if self.rowClicked <= 0
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
                if self.rowClicked <= 1
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
                if self.rowClicked <= 1
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
                if self.rowClicked <= 1
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
                if self.rowClicked <= 1
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
                if self.rowClicked <= 2
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
    
    override init() {
        super.init()
        // start doing something here maybe
    }
}
