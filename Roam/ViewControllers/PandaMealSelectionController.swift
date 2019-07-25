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
    
    let button = UIButton.init(type: .roundedRect)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showCartButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // send button just below the bottom of the screen
        UIView.animate(withDuration: 0.5, animations: {
            self.button.center.y = self.view.frame.height * 1.05
        })
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
                PandaSideSelectionVC.totalPrice = PandaExpress.Plate.price
            case 3:
                PandaSideSelectionVC.foodItem = "Bigger Plate"
                PandaSideSelectionVC.totalPrice = PandaExpress.BiggerPlate.price
            case 5:
                PandaSideSelectionVC.foodItem = "Bowl"
                PandaSideSelectionVC.totalPrice = PandaExpress.Bowl.price
            default:
                PandaSideSelectionVC.foodItem = "Family Feast"
                PandaSideSelectionVC.totalPrice = PandaExpress.FamilyFeast.price
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
    
    
    func showCartButton() {
        let order = Order.getOrder()
        
        if order.itemNames.count > 0 {
            
            // create and format button
            button.frame = CGRect(x: 150.0, y: self.view.frame.height, width: self.view.frame.width * 0.8, height: 50.0)
            button.setTitle("View \(order.itemNames.count) Items in Cart", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
            button.backgroundColor = .black
            button.center.x = self.view.center.x
            button.layer.cornerRadius = 20
            
            self.view.addSubview(button)
            button.addTarget(self, action: #selector(handleDismis(_:)), for: .touchUpInside)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.button.center.y = self.view.frame.height * 0.95
            })
        }
    }
    
    @objc func handleDismis(_: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let OrderVC = storyboard.instantiateViewController(withIdentifier: "OrderViewController")
        self.navigationController?.present(OrderVC, animated: true, completion: {
            print("VC Presented")
        })
    }

}
