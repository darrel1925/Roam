//
//  ChooseEntreeCell.swift
//  Roam
//
//  Created by Kay Lab on 5/28/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class ChooseEntreeCell: UITableViewCell {

    @IBOutlet weak var entreeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var checkView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
