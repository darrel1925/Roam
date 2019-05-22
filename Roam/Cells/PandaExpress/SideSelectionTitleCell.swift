//
//  SideSelectionTitleCell.swift
//  Roam
//
//  Created by Kay Lab on 5/22/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class SideSelectionTitleCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
