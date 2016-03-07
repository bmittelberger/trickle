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
    
    @IBOutlet weak var NewGroupButton: UIBarButtonItem!
    var groups: [Group] = []
    var groupMappings: [Int: Int] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if !User.me.currentOrganization().isAdmin {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadGroups()
    }
    
    func loadGroups() {
        // Attempt to load groups
        API.request(path: "users/me/groups") { (err, json) in
            if err {
                Error.showFromRequest(json, location: self)
                return
            }
            
            // We have groups to display, update the table
            var index = 0
            self.groups = json["groups"].map { (i, group) in
                let g = Group.fromJSON(group)
                self.groupMappings[g.id] = index++
                return g
            }
            if self.groups.count == 0 {
                let refreshAlert = UIAlertController(title: "Important", message: "You are not in any groups yet. Please contact your organization administrator to be added to groups.", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                }))
                
                
                self.presentViewController(refreshAlert, animated: true, completion: nil)
            } else {
                self.groups.forEach({ (group) in
                    if group.parentGroupId != 0 {
                        if let parentRowIndex = self.groupMappings[group.parentGroupId] {
                            group.name = "\(self.groups[parentRowIndex].name) / \(group.name)"
                        }
                    }
                })
            }
            self.MyGroupsTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func NewGroupPressed(sender: AnyObject) {
        Group.create(location: self) { (group) in
            self.groups.append(group)
            self.MyGroupsTableView.reloadData()
        }
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
