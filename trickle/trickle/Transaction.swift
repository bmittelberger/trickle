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

class Transaction {
    
    enum Status: String {
        case Pending = "PENDING"
        case Approved = "APPROVED"
        case Declined = "DECLINED"
    }
    
    var id = 0
    var amount = 0.0
    var title = ""
    var location = ""
    var category = ""
    var status = Status.Pending
    var user = User()
    var groupId = 0
    var creditId = 0
    
    func colorForStatus() -> UIColor {
        var color: UIColor
        switch status {
        case .Pending:
            color = UIColor.init(red: 52 / 255.0, green: 73 / 255.0, blue: 94 / 255.0, alpha: 1)
        case .Approved:
            color = UIColor.init(red: 39 / 255.0, green: 174 / 255.0, blue: 96 / 255.0, alpha: 1)
        case .Declined:
            color = UIColor.init(red: 192 / 255.0, green: 57 / 255.0, blue: 43 / 255.0, alpha: 1)
        }
        return color
    }
    
    class func fromJSON(json: JSON) -> Transaction {
        let t = Transaction()
        t.id = json["id"].intValue
        t.amount = json["amount"].doubleValue
        t.title = json["title"].stringValue
        t.location = json["location"].stringValue
        t.category = json["category"].stringValue
        t.status = Status(rawValue: json["status"].stringValue)!
        if json["User"].isExists() {
            t.user = User.fromJSON(json["User"])
        } else {
            t.user.id = json["UserId"].intValue
        }
        t.groupId = json["GroupId"].intValue
        t.creditId = json["CreditId"].intValue
        return t
    }
}