//
//  MyGroupsViewController.swift
//  trickle
//
//  Created by Kevin Moody on 2/6/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

class MyGroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var MyGroupsTableView: UITableView!
    
    var groups: [Group] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Attempt to load groups
        API.request(path: "users/me/groups") { (err, json) in
            if err {
                Error.showFromRequest(json, location: self)
                return
            }
            
            // We have groups to display, update the table
            self.groups = json["groups"].map { (i, group) in
                return Group.fromJSON(group)
            }
            self.MyGroupsTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupRow", forIndexPath: indexPath)
        cell.textLabel?.text = groups[indexPath.item].name
        cell.detailTextLabel?.text = groups[indexPath.item].description
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        GroupTableViewController.group = groups[indexPath.item]
        
        let groupTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GroupTableViewController") as! GroupTableViewController
        self.navigationController?.pushViewController(groupTableViewController, animated: true)
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
