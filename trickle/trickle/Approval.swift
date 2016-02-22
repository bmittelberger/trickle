//
//  Approval.swift
//  trickle
//
//  Created by Kevin Moody on 2/21/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class Approval {
    
    enum Status: String {
        case Active = "ACTIVE"
        case Approved = "APPROVED"
        case Declined = "DECLINED"
        case Expired = "EXPIRED"
    }
    
    var id = 0
    var message = ""
    var status = Status.Active
    var transaction = Transaction()
    var userId = 0
    var creditId = 0
    
    func colorForStatus() -> UIColor {
        var color: UIColor
        switch status {
        case .Active:
            color = UIColor.init(red: 52 / 255.0, green: 73 / 255.0, blue: 94 / 255.0, alpha: 1)
        case .Approved:
            color = UIColor.init(red: 39 / 255.0, green: 174 / 255.0, blue: 96 / 255.0, alpha: 1)
        case .Declined:
            color = UIColor.init(red: 192 / 255.0, green: 57 / 255.0, blue: 43 / 255.0, alpha: 1)
        case .Expired:
            color = UIColor.init(red: 192 / 255.0, green: 57 / 255.0, blue: 43 / 255.0, alpha: 1)
        }
        return color
    }
    
    class func fromJSON(json: JSON) -> Approval {
        let a = Approval()
        a.id = json["id"].intValue
        a.message = json["message"].stringValue
        a.status = Status(rawValue: json["status"].stringValue)!
        a.transaction = Transaction.fromJSON(json["Transaction"])
        a.userId = json["UserId"].intValue
        a.creditId = json["CreditId"].intValue
        return a
    }
}