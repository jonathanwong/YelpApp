//
//  SwitchTableViewCell.swift
//  Yelp
//
//  Created by Jonathan Wong on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchTableViewCellDelegate {
    @objc optional func switchTableViewCell(switchTableViewCell: SwitchTableViewCell, didChangeValue value: Bool)
}

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    weak var switchTableViewCellDelegate: SwitchTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        onSwitch.addTarget(self, action: #selector(SwitchTableViewCell.switchValueChanged), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchValueChanged() {
        switchTableViewCellDelegate?.switchTableViewCell!(switchTableViewCell: self, didChangeValue: onSwitch.isOn)
    }
}
