//
//  CreditLineTableViewCell.swift
//  trickle
//
//  Created by Kevin Moody on 2/15/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

class CreditLineTableViewCell: UITableViewCell {
    
    var credit = Credit()

    @IBOutlet weak var CreditNameTextLabel: UILabel!
    @IBOutlet weak var CreditAmountTextLabel: UILabel!
    
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
        credit.drawBalanceCicle(bounds.minX + 16 + 10, y: bounds.midY)
    }

}
