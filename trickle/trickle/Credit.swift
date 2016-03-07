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

class Credit {
    
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
    
    func balancePercentage() -> Double {
        return balance / amount
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
        return c
    }
}