//
//  OrderDetailsCell.swift
//  Roam
//
//  Created by Darrel Muonekwu on 7/7/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class OrderDetailsCell: UITableViewCell {

    @IBOutlet weak var numOrdersLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
