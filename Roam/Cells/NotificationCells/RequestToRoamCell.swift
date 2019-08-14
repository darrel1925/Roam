//
//  RequestToRoamCell.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/14/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class RequestToRoamCell: UITableViewCell {

    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var notificationId: UILabel!
    @IBOutlet weak var notificationDiscription: UILabel!
    @IBOutlet weak var notificationDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
