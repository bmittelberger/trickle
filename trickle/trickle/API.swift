//
//  API.swift
//  trickle
//
//  Created by Kevin Moody on 1/31/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class API {
    
    static let rootUrl = "http://52.35.136.102/api/v0/"
    
    static var accessToken = ""
    
    class func request(method: Alamofire.Method = .GET,
        path: String,
        parameters: [String : AnyObject] = [String : AnyObject](),
        handler: (Bool, JSON) -> Void)
    {
        Alamofire
            .request(method, self.rootUrl + path, parameters: parameters, headers: [
                    "x-access-token": accessToken
                ])
            .responseJSON { response in
                switch response.result {
                    case .Success:
                        let json = JSON(response.result.value!)
                        let error = json["error"].isExists()
                        handler(error, json)
                    case .Failure:
                        handler(true, JSON(["error": "An error occurred."]))
                }
            }
    }
    
    class func authenticate(email: String,
        password: String,
        handler: (Bool, JSON) -> Void)
    {
        API.request(.POST, path: "authentication", parameters: [
                "email": email,
                "password": password
            ], handler: { (error, json) -> Void in
                if !error {
                    if let token = json["token"].string {
                        self.accessToken = token
                        User.me = User.fromJSON(json["user"])
                    }
                }
                
                // then call the user-defined handler
                handler(error, json)
            })
    }
    
}