//
//  User.swift
//  trickle
//
//  Created by Kevin Moody on 2/1/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    
    static var me: User = User()
    
    var id = 0
    var first = ""
    var last = ""
    var email = ""
    
    class func fromJSON(json: JSON) -> User {
        let u = User()
        u.id = json["id"].intValue
        u.first = json["first"].stringValue
        u.last = json["last"].stringValue
        u.email = json["email"].stringValue
        return u
    }
}