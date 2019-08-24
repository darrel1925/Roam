//
//  EarningsDetailCell.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/1/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class EarningsDetailCell: UITableViewCell {

    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var moneyEarnedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
