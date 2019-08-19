//
//  ProfileController.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/18/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView
        statusBar?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.navigationController?.navigationBar.barStyle = .default
    }
    

}

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ProfileSectionCell) as! ProfileSectionCell
            cell.sectionTitle.text = "Basic Info"
            cell.sectionImage.image = UIImage(named: "pencil")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ProfileInfoCell) as! ProfileInfoCell
            switch row {
            case 0:
                cell.infoTitle.text = "Display Name"
                cell.infoDescription.text = "MyName"
                return cell
            case 1:
                cell.infoTitle.text = "User Name"
                cell.infoDescription.text = "@username"
                return cell
            case 2:
                cell.infoTitle.text = "Email"
                cell.infoDescription.text = "dmuonekw@uci.edu"
                return cell
            case 3:
                cell.infoTitle.text = "Phone"
                cell.infoDescription.text = "(925)848-8888"
                return cell
            default:
                return cell
            }
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ProfileSectionCell) as! ProfileSectionCell
            cell.sectionTitle.text = "Account Info"
            cell.sectionImage.image = nil
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ProfileInfoCell) as! ProfileInfoCell
            switch row {
            case 0:
                cell.infoTitle.text = "Payment Info"
                cell.infoDescription.text = "Visa"
                return cell
            default:
                return cell
            }
        default:
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ProfileInfoCell) as! ProfileInfoCell
        return cell
    }
    
    
}
