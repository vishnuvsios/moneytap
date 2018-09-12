//
//  CustomTableViewCell.swift
//  moneyTap
//
//  Created by Vishnuvarthan Deivendiran on 11/09/18.
//  Copyright © 2018 Vishnuvarthan Deivendiran. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var articleImageview: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleDetails1: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
