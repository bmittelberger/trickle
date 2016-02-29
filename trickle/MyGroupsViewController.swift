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
    
    @IBAction func NewGroupPressed(sender: AnyObject) {
        let alert = UIAlertController(title: "Create a Group", message: "", preferredStyle: UIAlertControllerStyle.Alert)
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
                API.request(.POST, path: "groups", parameters: [
                    "name": name,
                    "description": description,
                    "OrganizationId": User.me.currentOrganization().id
                ], handler: { (error, json) in
                    if error {
                        Error.showFromRequest(json, location: self)
                        return
                    }
                    
                    self.groups.insert(Group.fromJSON(json["group"]), atIndex: 0)
                    
                    self.MyGroupsTableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
                    
//                    self.MyGroupsTableView.reloadData()
                })
            } else {
                alert.message = "Please provide a group name and description."
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
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
