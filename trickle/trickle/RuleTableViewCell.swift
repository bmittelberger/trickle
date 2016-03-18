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
    
    @IBOutlet weak var ruleStory: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
