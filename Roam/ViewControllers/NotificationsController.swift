//
//  NotificationsController.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/14/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class NotificationsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var notificationsCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setTitle()
    }
    
    func setTitle() {
        if NotificationService.count == 1 {
            notificationsLabel.text = "Notification"
        }
        else {
            notificationsLabel.text = "Notifications"
        }
        
        notificationsCountLabel.text = String(NotificationService.count)
        
    }


}

extension NotificationsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestToRoamCell") as! RequestToRoamCell
        
        return cell
    }
    
    
}
