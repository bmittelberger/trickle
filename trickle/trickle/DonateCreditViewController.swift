//
//  DonateCreditViewController.swift
//  trickle
//
//  Created by Ben Mittelberger on 3/15/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

class DonateCreditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var subGroups : [Group] = []
    
    @IBOutlet weak var availableAmountLabel: UILabel!
    @IBOutlet weak var subGroupTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Donate a Line of Credit"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadSubGroups()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currGroup = self.subGroups[indexPath.item]
        let cell = tableView.dequeueReusableCellWithIdentifier("subGroupCell")
        cell?.textLabel?.text =  currGroup.name
        cell?.detailTextLabel?.text = currGroup.description
        return cell!
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subGroups.count
    }
    
    
    
    func loadSubGroups() {
        API.request(path: "/groups/\(GroupTableViewController.group.id)/groups") { (err, json) in
            if err {
                Error.showFromRequest(json, location: self)
                return
            }
            self.subGroups = json["groups"].map { (i, group) in
                return Group.fromJSON(group)
            }
        }
    }
    
//    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Select Sub Group To Donate To"
//    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
