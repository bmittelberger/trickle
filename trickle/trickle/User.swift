//
//  User.swift
//  trickle
//
//  Created by Kevin Moody on 2/1/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import Foundation
import SwiftyJSON

class User : Model {
    
    static var me: User = User()
    
    var id = 0
    var first = ""
    var last = ""
    var email = ""
    var organizations: [Organization] = []
    
    var displayName: String {
        return "\(first) \(last)"
    }
    
    func currentOrganization() -> Organization {
        return self.organizations[0]
    }
    
    class func fromJSON(json: JSON) -> User {
        let u = User()
        u.id = json["id"].intValue
        u.first = json["first"].stringValue
        u.last = json["last"].stringValue
        u.email = json["email"].stringValue
        if json["Organizations"].isExists() {
            u.organizations = json["Organizations"].map({ (i, organization) in
                return Organization.fromJSON(organization)
            })
        }
        return u
    }
}