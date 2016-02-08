//
//  GroupViewController.swift
//  trickle
//
//  Created by Kevin Moody on 2/4/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    
    static var group: Group = Group()
    
    var credits: [Credit] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = GroupViewController.group.name
        
        // Attempt to load credits
        API.request(path: "groups/\(GroupViewController.group.id)/credits") { (err, json) in
            if err {
                Error.showFromRequest(json, location: self)
                return
            }
            
            // We have groups to display, update the table
            self.credits = json["credits"].map { (i, credit) in
                return Credit.fromJSON(credit)
            }
            //self.MyGroupsTableView.reloadData()
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
