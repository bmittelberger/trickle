//
//  User.swift
//  trickle
//
//  Created by Kevin Moody on 2/6/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import Foundation
import SwiftyJSON

class Credit {
    
    var id = 0
    var amount = 0.0
    var balance = 0.0
    var description = ""
    var groupId = 0
    var parentCreditId = 0
    
    class func fromJSON(json: JSON) -> Credit {
        let c = Credit()
        c.id = json["id"].intValue
        c.amount = json["amount"].doubleValue
        c.balance = json["balance"].doubleValue
        c.description = json["description"].stringValue
        c.groupId = json["GroupId"].intValue
        c.parentCreditId = json["ParentCreditId"].intValue
        return c
    }
}