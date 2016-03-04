//
//  RuleTableViewCell.swift
//  trickle
//
//  Created by Ben Mittelberger on 3/3/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

class RuleTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var ruleTypeVal: UILabel!
    @IBOutlet weak var maxVal: UILabel!
    @IBOutlet weak var minVal: UILabel!
    @IBOutlet weak var thresholdVal: UILabel!
    @IBOutlet weak var approvalVal: UILabel!
    @IBOutlet weak var windowVal: UILabel!
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
