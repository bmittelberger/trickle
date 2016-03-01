//
//  ApprovalTableViewCell.swift
//  trickle
//
//  Created by Kevin Moody on 2/29/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

class ApprovalTableViewCell: UITableViewCell {

    @IBOutlet weak var ApprovalMessageLabel: UILabel!
    
    @IBOutlet weak var ApproveButton: UIButton!
    @IBOutlet weak var DeclineButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
