//
//  User.swift
//  trickle
//
//  Created by Kevin Moody on 2/6/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit



public class Rule {
    public struct RuleType {
        static let WINDOW_LIMIT : String = "RULE_TYPE_WINDOW_LIMIT"
        static let RANGE_APPROVAL : String = "RULE_TYPE_RANGE_APPROVAL"
    }
    
    public struct Window {
        static let DAY : String =  "WINDOW_DAY"
        static let WEEK : String =  "WINDOW_WEEK"
        static let MONTH : String = "WINDOW_MONTH"
    }
    
    public struct CreditSide {
        static let EXTENDER : String = "CREDIT_SIDE_EXTENDER"
        static let RECEIVER : String = "CREDIT_SIDE_RECEIVER"
    }
    
    public struct ApprovalType {
        static let NUMBER_MEMBER : String = "APPROVAL_TYPE_NUMBER_MEMBER"
        static let PERCENTAGE_MEMBER : String = "APPROVAL_TYPE_PERCENTAGE_MEMBER"
        static let NUMBER_ADMIN : String = "APPROVAL_TYPE_NUMBER_ADMIN"
        static let PERCENTAGE_ADMIN : String = "APPROVAL_TYPE_PERCENTAGE_ADMIN"
        static let DECLINE : String =  "APPROVAL_TYPE_DECLINE"
    }


    
    
    var type : String = ""
    var window : String = ""
    var side : String = ""
    var approval : String = ""
    var min : float_t = 0
    var max : float_t = 0
    var threshold : Int = 0
    
    class func fromJSON(json: JSON) -> Rule {
        let r = Rule()
        r.min = json["min"].floatValue
        if json["max"] != JSON.null {
            r.max = json["max"].floatValue
        } else {
            r.max = -1
        }
        r.type = json["type"].stringValue
        r.window = json["window"].stringValue
        r.approval = json["approval"].stringValue
        r.threshold = json["threshold"].intValue
        r.side = json["threshold"].stringValue
        return r
    }
    
    class func toJSON(rule : Rule) -> JSON {
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        var data:[String:String] = [
            "approval" : rule.approval,
            "min" : String(rule.min),
            "max" : String(rule.max),
            "type" : rule.type,
            "threshold" :String (rule.threshold),
            "side" : rule.side,
            "window" : rule.window
        ]
        if Float(data["max"] as String!) == -1.0 {
            data.removeValueForKey("max")
        }
        if Int(data["threshold"] as String!) == -1 {
            data.removeValueForKey("threshold")
        }
        if data["window"] == "" {
            data.removeValueForKey("window")
        }
        return JSON(data)
    }
    
    
    func ruleStory() -> NSAttributedString? {
        let formatter = NSNumberFormatter()
        let regFormatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        let bolded = [ NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 17.0)! ]
        let nonBolded = [ NSFontAttributeName: UIFont(name: "Avenir", size: 17.0)! ]
        let story = NSMutableAttributedString(string: (""), attributes: nonBolded)
        if self.type == Rule.RuleType.WINDOW_LIMIT {
            story.appendAttributedString(NSMutableAttributedString(string: ("A "), attributes: nonBolded))
            if self.window == Rule.Window.DAY {
                story.appendAttributedString(NSMutableAttributedString(string: ("daily "), attributes: bolded))
            } else if self.window == Rule.Window.WEEK {
                story.appendAttributedString(NSMutableAttributedString(string: ("weekly "), attributes: bolded))
            } else if self.window == Rule.Window.MONTH {
                story.appendAttributedString(NSMutableAttributedString(string: ("monthly "), attributes: bolded))
            }
            story.appendAttributedString(NSMutableAttributedString(string: ("cumulative sum of "), attributes: nonBolded))
        }
        story.appendAttributedString(NSMutableAttributedString(string: ("Reimbursements "), attributes: nonBolded))
        if self.max > -1 {
            story.appendAttributedString( NSMutableAttributedString(string: ("between "), attributes: nonBolded))
            story.appendAttributedString(NSMutableAttributedString(string: formatter.stringFromNumber(self.min)!, attributes: bolded))
            story.appendAttributedString( NSMutableAttributedString(string: (" and "), attributes: nonBolded))
            story.appendAttributedString(NSMutableAttributedString(string: formatter.stringFromNumber(self.max)!, attributes: bolded))
        } else {
            story.appendAttributedString( NSMutableAttributedString(string: ("over "), attributes: nonBolded))
            story.appendAttributedString(NSMutableAttributedString(string: formatter.stringFromNumber(self.min)!, attributes: bolded))
        }
        if self.approval == Rule.ApprovalType.DECLINE {
            story.appendAttributedString( NSMutableAttributedString(string: (" are automatically declined."), attributes: bolded))
        } else {
            story.appendAttributedString( NSMutableAttributedString(string: (" require "), attributes: nonBolded))
            if self.approval == Rule.ApprovalType.NUMBER_ADMIN {
                story.appendAttributedString( NSMutableAttributedString(string: ("approval from "), attributes: nonBolded))
                story.appendAttributedString(NSMutableAttributedString(string: regFormatter.stringFromNumber(self.threshold)!, attributes: bolded))
                story.appendAttributedString( NSMutableAttributedString(string: (" admins."), attributes: bolded))
            }
            if self.approval == Rule.ApprovalType.NUMBER_MEMBER {
                story.appendAttributedString( NSMutableAttributedString(string: ("approval from "), attributes: nonBolded))
                story.appendAttributedString(NSMutableAttributedString(string: regFormatter.stringFromNumber(self.threshold)!, attributes: bolded))
                story.appendAttributedString( NSMutableAttributedString(string: (" members."), attributes: bolded))
            }
            if self.approval == Rule.ApprovalType.PERCENTAGE_ADMIN {
                story.appendAttributedString( NSMutableAttributedString(string: ("approval from "), attributes: nonBolded))
                story.appendAttributedString(NSMutableAttributedString(string: regFormatter.stringFromNumber(self.threshold)!, attributes: bolded))
                story.appendAttributedString( NSMutableAttributedString(string: ("% of admins."), attributes: bolded))
            }
            if self.approval == Rule.ApprovalType.PERCENTAGE_MEMBER {
                story.appendAttributedString( NSMutableAttributedString(string: ("approval from "), attributes: nonBolded))
                story.appendAttributedString(NSMutableAttributedString(string: regFormatter.stringFromNumber(self.threshold)!, attributes: bolded))
                story.appendAttributedString( NSMutableAttributedString(string: ("% of members."), attributes: bolded))
            }
        }
        
        return story
    }
}
