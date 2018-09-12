//
//  HomeViewController.swift
//  wikipedia
//
//  Created by Vishnuvarthan Deivendiran on 11/09/18.
//  Copyright © 2018 Vishnuvarthan Deivendiran. All rights reserved.
//


import UIKit

class MenuItemCell: UITableViewCell {

    @IBOutlet weak var m_TitleLbl: UILabel!
    @IBOutlet weak var m_SeperaterView: UIImageView!
    @IBOutlet weak var m_itemTitleView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setImageContent(title : String)  {
        m_itemTitleView.image = UIImage(named:title)
        
    }
    func setContent(title : String)  {
        m_TitleLbl.text = title
        
    }
}
