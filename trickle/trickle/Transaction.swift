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
    var date = ""
    var groupId = 0
    var creditId = 0
    var groupName = ""
    var userName = ""
    var creditName = ""
    var stateInfo = JSON("")
    
    var imageURL: String {
        return "\(id).png"
    }
    
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
        t.userName = json["User"]["first"].stringValue
        t.userName += " " + json["User"]["last"].stringValue
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.dateFromString(json["createdAt"].stringValue)
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        t.date = dateFormatter.stringFromDate(date!)
        t.groupId = json["GroupId"].intValue
        t.creditId = json["CreditId"].intValue
        t.groupName = json["Group"]["name"].stringValue
        t.creditName = json["Credit"]["description"].stringValue
        t.stateInfo = json["stateInfo"]
        return t
    }
    
    func transactionStory() -> NSAttributedString {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        let bolded = [ NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 18.0)! ]
        let nonBolded = [ NSFontAttributeName: UIFont(name: "Avenir", size: 18.0)! ]
        let story = NSMutableAttributedString(string: (self.userName), attributes: bolded)
        story.appendAttributedString(NSMutableAttributedString(string: " requested ", attributes: nonBolded))
        story.appendAttributedString(NSMutableAttributedString(string: formatter.stringFromNumber((self.amount))!, attributes: bolded))
        story.appendAttributedString(NSMutableAttributedString(string: " on ", attributes: nonBolded))
        story.appendAttributedString(NSMutableAttributedString(string: (self.date), attributes: bolded))
        story.appendAttributedString(NSMutableAttributedString(string: " for ", attributes: nonBolded))
        story.appendAttributedString(NSMutableAttributedString(string: (self.title), attributes: bolded))
        return story
    }
    
    func creditStory() -> NSAttributedString {
        let bolded = [ NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 18.0)! ]
        let nonBolded = [ NSFontAttributeName: UIFont(name: "Avenir", size: 18.0)! ]
        let creditStory = NSMutableAttributedString(string: "Requested from the ", attributes: nonBolded)
        creditStory.appendAttributedString(NSMutableAttributedString(string: (self.creditName), attributes: bolded))
        creditStory.appendAttributedString(NSMutableAttributedString(string: " credit in the ", attributes: nonBolded))
        creditStory.appendAttributedString(NSMutableAttributedString(string: (self.groupName), attributes: bolded))
        creditStory.appendAttributedString(NSMutableAttributedString(string: " group.", attributes: nonBolded))
        return creditStory
    }
}