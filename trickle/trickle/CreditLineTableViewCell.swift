//
//  CreditLineTableViewCell.swift
//  trickle
//
//  Created by Kevin Moody on 2/15/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

class CreditLineTableViewCell: UITableViewCell {
    
    var balancePercentage: CGFloat = 0.0
    var color: UIColor = UIColor.orangeColor()

    @IBOutlet weak var CreditNameTextLabel: UILabel!
    @IBOutlet weak var CreditAmountTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // No background color, white text
        self.backgroundColor = UIColor.clearColor()
        self.CreditNameTextLabel?.textColor = UIColor.whiteColor()
        self.CreditAmountTextLabel?.textColor = UIColor.whiteColor()
        
        // Set fonts
        self.CreditNameTextLabel?.font = UIFont(name: "Avenir", size: 20)
        self.CreditAmountTextLabel?.font = UIFont(name: "Avenir", size: 20)
//        
//        // Resize labels
//        self.detailTextLabel?.sizeToFit()
//        self.textLabel?.sizeToFit()
        
        // Draw background and progress bars
        drawBackgroundBar(color: color.colorWithAlphaComponent(0.8))
        drawBackgroundBar(balancePercentage, color: color)
    }
    
    func drawBackgroundBar(percentage: CGFloat = 1.0, color: UIColor) {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: bounds.minX, y: bounds.minY))
        path.addLineToPoint(CGPoint(x: bounds.width * percentage, y: bounds.minY))
        path.addLineToPoint(CGPoint(x: bounds.width * percentage, y: bounds.maxY))
        path.addLineToPoint(CGPoint(x: bounds.minX, y: bounds.maxY))
        path.addLineToPoint(CGPoint(x: bounds.minX, y: bounds.minY))
        color.setFill()
        path.fill()
    }

}
