//
//  Organization.swift
//  trickle
//
//  Created by Kevin Moody on 2/28/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import Foundation
import SwiftyJSON

class Organization : Model {
    
    var id = 0
    var name = ""
    var description = ""
    var isAdmin = false
    
    var displayName: String {
        return name
    }
    
    class func fromJSON(json: JSON) -> Organization {
        let o = Organization()
        o.id = json["id"].intValue
        o.name = json["name"].stringValue
        o.description = json["description"].stringValue
        o.isAdmin = json["UserOrganization"]["isAdmin"].boolValue
        return o
    }
}