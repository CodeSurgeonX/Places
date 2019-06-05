//
//  CategoryTableViewCell.swift
//  Places App
//
//  Created by Shashwat  on 05/06/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categoryNameLabel.font = UIFont.preferredFont(forTextStyle: .title1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
