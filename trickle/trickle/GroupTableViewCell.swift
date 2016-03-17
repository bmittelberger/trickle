//
//  GroupTableViewCell.swift
//  trickle
//
//  Created by Kevin Moody on 3/16/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    var group = Group()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        var offset = CGFloat(16 + 10)
        for credit in group.credits {
            credit.drawBalanceCicle(bounds.maxX - offset, y: bounds.midY)
            offset += 14
        }
    }

}
