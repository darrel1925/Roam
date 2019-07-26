//
//  ShoppingCartCell.swift
//  Roam
//
//  Created by Darrel Muonekwu on 7/24/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class ShoppingCartCell: UITableViewCell {

    @IBOutlet weak var numItemsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
