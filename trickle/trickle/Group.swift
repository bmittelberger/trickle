//
//  User.swift
//  trickle
//
//  Created by Kevin Moody on 2/6/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import Foundation
import SwiftyJSON

class Group {
    
    var id = 0
    var name = ""
    var description = ""
    var organizationId = 0
    var isAdmin = false
    
    class func fromJSON(json: JSON) -> Group {
        let g = Group()
        g.id = json["id"].intValue
        g.name = json["name"].stringValue
        g.description = json["description"].stringValue
        g.organizationId = json["OrganizationId"].intValue
        g.isAdmin = json["UserGroup"]["isAdmin"].boolValue
        return g
    }
}