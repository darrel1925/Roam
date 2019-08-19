//
//  ProfileSectionCell.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/18/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class ProfileSectionCell: UITableViewCell {

    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var sectionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
