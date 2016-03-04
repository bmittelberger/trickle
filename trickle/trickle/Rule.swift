//
//  User.swift
//  trickle
//
//  Created by Kevin Moody on 2/6/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import Foundation
import SwiftyJSON



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
        r.max = json["max"].floatValue
        r.type = json["type"].stringValue
        r.window = json["window"].stringValue
        r.approval = json["approval"].stringValue
        r.threshold = json["threshold"].intValue
        return r
    }
}
