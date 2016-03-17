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

class Group : Model {
    
    var id = 0
    var name = ""
    var description = ""
    var organizationId = 0
    var parentGroupId = 0
    var isAdmin = false
    var credits: [Credit] = []
    
    func createSubgroup(location: UIViewController, handler: (Group) -> Void) {
        Group.create(self, location: location, handler: handler)
    }
    
    var displayName: String {
        return name
    }
    
    class func create(parent: Group? = nil, location: UIViewController, handler: (Group) -> Void) {
        let alert: UIAlertController
        let path: String
        if let p = parent {
            alert = UIAlertController(title: "Create a Subgroup", message: "Create a subgroup within \(p.name).", preferredStyle: UIAlertControllerStyle.Alert)
            path = "groups/\(p.id)/groups"
        } else {
            alert = UIAlertController(title: "Create a Group", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            path = "groups"
        }
        
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Group Name"
            textField.secureTextEntry = false
        })
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Description"
            textField.secureTextEntry = false
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .Default, handler: { (alertAction:UIAlertAction!) in
            let nameTextField = alert.textFields![0] as UITextField
            let descriptionTextField = alert.textFields![1] as UITextField
            let name = nameTextField.text!
            let description = descriptionTextField.text!
            
            if name != "" && description != "" {
                API.request(.POST, path: path, parameters: [
                    "name": name,
                    "description": description,
                    "OrganizationId": User.me.currentOrganization().id
                    ], handler: { (error, json) in
                        if error {
                            Error.showFromRequest(json, location: location)
                            return
                        }
                        
                        let group = Group.fromJSON(json["group"])
                        handler(group)
                })
            } else {
                alert.message = "Please provide a group name and description."
                location.presentViewController(alert, animated: true, completion: nil)
            }
            
        }))
        location.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func fromJSON(json: JSON) -> Group {
        let g = Group()
        g.id = json["id"].intValue
        g.name = json["name"].stringValue
        g.description = json["description"].stringValue
        g.organizationId = json["OrganizationId"].intValue
        g.parentGroupId = json["ParentGroupId"].isExists() ? json["ParentGroupId"].intValue : 0
        g.isAdmin = json["UserGroup"]["isAdmin"].boolValue
        if json["Credits"].isExists() {
            g.credits = json["Credits"].map({ (i, credit) in
                return Credit.fromJSON(credit)
            })
        }
        return g
    }
}