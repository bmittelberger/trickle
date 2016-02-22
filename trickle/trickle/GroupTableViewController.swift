//
//  GroupTableViewController.swift
//  trickle
//
//  Created by Kevin Moody on 2/6/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

class GroupTableViewController: UITableViewController {
    
    static var group: Group = Group()
    
    var credits: [Credit] = []
    
    static let creditColors = [
        // Green Sea
        UIColor.init(red: 22 / 255.0, green: 160 / 255.0, blue: 133 / 255.0, alpha: 1),
        // Nephritis
        UIColor.init(red: 39 / 255.0, green: 174 / 255.0, blue: 96 / 255.0, alpha: 1),
        // Belize Hole
        UIColor.init(red: 41 / 255.0, green: 128 / 255.0, blue: 185 / 255.0, alpha: 1),
        // Wisteria
        UIColor.init(red: 142 / 255.0, green: 68 / 255.0, blue: 173 / 255.0, alpha: 1),
        // Midnight Blue
        UIColor.init(red: 44 / 255.0, green: 62 / 255.0, blue: 80 / 255.0, alpha: 1),
        // Orange
        UIColor.init(red: 243 / 255.0, green: 156 / 255.0, blue: 18 / 255.0, alpha: 1),
        // Pumpkin
        UIColor.init(red: 211 / 255.0, green: 84 / 255.0, blue: 0 / 255.0, alpha: 1),
        // Pomegranate
        UIColor.init(red: 192 / 255.0, green: 57 / 255.0, blue: 43 / 255.0, alpha: 1)
    ]
    
    var availableColors = GroupTableViewController.creditColors

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = GroupTableViewController.group.name
        
        self.loadCredits()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadCredits()
    }
    
    func loadCredits() {
        // Attempt to load credits
        API.request(path: "groups/\(GroupTableViewController.group.id)/credits") { (err, json) in
            if err {
                Error.showFromRequest(json, location: self)
                return
            }
            
            // We have groups to display, update the table
            self.credits = json["credits"].map { (i, credit) in
                let credit = Credit.fromJSON(credit)
                let hash = credit.description.hashValue
                let index = (hash > 0 ? hash : -hash) % self.availableColors.count
                credit.color = self.availableColors.removeAtIndex(index)
                if self.availableColors.isEmpty {
                    self.availableColors = GroupTableViewController.creditColors
                }
                return credit
            }
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Lines of Credit"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return credits.isEmpty ? 0 : 2 * credits.count - 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.item % 2 == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CreditRow", forIndexPath: indexPath) as! CreditLineTableViewCell
            
            let credit = credits[indexPath.item / 2]
            
            cell.textLabel?.text = credit.description
            cell.balancePercentage = CGFloat.init(credit.balancePercentage())
            cell.color = credit.color
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            formatter.maximumFractionDigits = 0
            cell.detailTextLabel?.text = formatter.stringFromNumber(credit.balance)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CreditRowMargin", forIndexPath: indexPath)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.item % 2 == 0 {
            CreditTransactionsTableViewController.credit = credits[indexPath.item / 2]
            
            let creditTransactionsTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CreditTransactionsTableViewController") as! CreditTransactionsTableViewController
            self.navigationController?.pushViewController(creditTransactionsTableViewController, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.item % 2 == 0 ? 108 : 1
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
