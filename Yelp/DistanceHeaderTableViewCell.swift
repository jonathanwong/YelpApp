//
//  DistanceHeaderTableViewCell.swift
//  Yelp
//
//  Created by Jonathan Wong on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class DistanceHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var chevron: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        chevron.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
