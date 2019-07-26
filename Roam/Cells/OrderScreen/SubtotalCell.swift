//
//  SubtotalCell.swift
//  Roam
//
//  Created by Darrel Muonekwu on 7/7/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class SubtotalCell: UITableViewCell {

    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var subtotalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
