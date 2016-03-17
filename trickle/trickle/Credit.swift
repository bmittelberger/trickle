//
//  User.swift
//  trickle
//
//  Created by Kevin Moody on 2/6/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class Credit : Model {
    
    static let colors = [
        // Green Sea
        UIColor.init(red: 22 / 255.0, green: 160 / 255.0, blue: 133 / 255.0, alpha: 1),
        // Nephritis
        UIColor.init(red: 39 / 255.0, green: 174 / 255.0, blue: 96 / 255.0, alpha: 1),
        // Belize Hole
        UIColor.init(red: 41 / 255.0, green: 128 / 255.0, blue: 185 / 255.0, alpha: 1),
        // Wisteria
        UIColor.init(red: 142 / 255.0, green: 68 / 255.0, blue: 173 / 255.0, alpha: 1),
        // Midnight Blue
        UIColor.init(red: 44 / 255.0, green: 62 / 255.0, blue: 80 / 255.0, alpha: 1),
        // Orange
        UIColor.init(red: 243 / 255.0, green: 156 / 255.0, blue: 18 / 255.0, alpha: 1),
        // Pumpkin
        UIColor.init(red: 211 / 255.0, green: 84 / 255.0, blue: 0 / 255.0, alpha: 1),
        // Pomegranate
        UIColor.init(red: 192 / 255.0, green: 57 / 255.0, blue: 43 / 255.0, alpha: 1)
    ]
    
    var id = 0
    var amount = 0.0
    var balance = 0.0
    var description = ""
    var groupId = 0
    var parentCreditId = 0
    var color: UIColor {
        let hash = description.hashValue
        let unsignedHash = hash < 0 ? -hash : hash
        return Credit.colors[unsignedHash % Credit.colors.count]
    }
    var rules : [Rule] = []
    
    var displayName: String {
        return description
    }
    
    func balancePercentage() -> Double {
        return balance / amount
    }
    
    func drawBalanceCicle(x: CGFloat, y: CGFloat) {
        let bg = UIBezierPath()
        bg.moveToPoint(CGPoint(x: x, y: y))
        bg.addArcWithCenter(CGPoint(x: x, y: y), radius: 12.0, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        UIColor(red: 242 / 255.0, green: 242 / 255.0, blue: 242 / 255.0, alpha: 1.0).setFill()
        bg.fill()
        for var opacity = 1.0; opacity > 0.0; opacity -= 0.8 {
            let percentage = opacity == 1 ? self.balancePercentage() : 1
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: x, y: y))
            path.addArcWithCenter(CGPoint(x: x, y: y), radius: 10.0, startAngle: -CGFloat(M_PI_2), endAngle: -CGFloat(M_PI_2) - CGFloat(2 * M_PI * percentage), clockwise: false)
            self.color.colorWithAlphaComponent(CGFloat(opacity)).setFill()
            path.fill()
        }
    }
    
    class func fromJSON(json: JSON) -> Credit {
        let c = Credit()
        c.id = json["id"].intValue
        c.amount = json["amount"].doubleValue
        c.balance = json["balance"].doubleValue
        c.description = json["description"].stringValue
        c.groupId = json["GroupId"].intValue
        c.parentCreditId = json["ParentCreditId"].intValue
        if json["rules"].isExists() {
            c.rules = json["rules"].map({ (i, rule) in
                return Rule.fromJSON(rule)
            })
        }
        c.rules.sortInPlace({ $0.min < $1.min })
        return c
    }
}