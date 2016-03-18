//
//  MainTabBarController.swift
//  trickle
//
//  Created by Kevin Moody on 3/17/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        API.request(path: "users/me/approvals?statuses=ACTIVE") { (err, json) in
            if err {
                return
            }
            
            let approvals = json["approvals"].map { (i, approval) in
                return true
            }
            
            self.tabBar.items![1].badgeValue = approvals.count != 0 ? "\(approvals.count)" : nil

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
