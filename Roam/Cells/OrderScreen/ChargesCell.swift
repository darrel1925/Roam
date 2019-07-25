//
//  ChargesCell.swift
//  Roam
//
//  Created by Darrel Muonekwu on 7/7/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class ChargesCell: UITableViewCell {

    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var taxPriceLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var servicePriceLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var deliveryPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
