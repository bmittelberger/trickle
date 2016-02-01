//
//  Error.swift
//  trickle
//
//  Created by Kevin Moody on 1/31/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Error {
    
    class func show(message: String, location: UIViewController)
    {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        location.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func showFromRequest(json: JSON, location: UIViewController)
    {
        self.show(json["error"].stringValue, location: location)
    }
    
}