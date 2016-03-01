
//
//  SelectOrganizationViewController.swift
//  trickle
//
//  Created by Kevin Moody on 2/28/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

class SelectOrganizationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var OrganizationSearchTextField: UITextField!
    @IBOutlet weak var OrganizationsSearchTableView: UITableView!
    
    var organizations: [Organization] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OrganizationSearchChanged(sender: AnyObject) {
        let query = OrganizationSearchTextField.text!
        
        if !query.isEmpty {
            API.request(path: "organizations?query=\(query)") { (error, json) in
                if error {
                    Error.showFromRequest(json, location: self)
                    return
                }
                
                self.organizations = json["organizations"].map({ (i, organization) in
                    return Organization.fromJSON(organization)
                })
                self.OrganizationsSearchTableView.reloadData()
            }
        } else {
            self.organizations = []
            self.OrganizationsSearchTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrganizationRow", forIndexPath: indexPath)
        cell.textLabel?.text = organizations[indexPath.item].name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let organization = organizations[indexPath.item]
        
        // deal with creating the user & adding them to the organization
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
