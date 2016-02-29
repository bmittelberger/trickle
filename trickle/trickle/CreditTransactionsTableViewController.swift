//
//  CreditTransactionsTableViewController.swift
//  trickle
//
//  Created by Kevin Moody on 2/9/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

class CreditTransactionsTableViewController: UITableViewController {
    
    static var credit: Credit = Credit()
    
    var transactions: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = CreditTransactionsTableViewController.credit.description
        
        let addButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("newTransactionPressed"))
        self.navigationItem.rightBarButtonItem = addButton
        
//        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//            target:self
//            action:@selector(addButtonPressed:)];
//        self.navigationItem.rightBarButtonItem  = addButton;
//        
//        addButton.
//        [addButton release], addButton = nil;
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadTransactions()
    }
    
    func loadTransactions() {
        API.request(path: "credits/\(CreditTransactionsTableViewController.credit.id)/transactions") { (err, json) in
            if err {
                Error.showFromRequest(json, location: self)
                return
            }
            
            // We have transactions to display, update the table
            self.transactions = json["transactions"].map { (i, transaction) in
                return Transaction.fromJSON(transaction)
            }
            self.tableView.reloadData()
        }
    }
    
    func newTransactionPressed() {
        let reimbursementViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ReimbursementViewController") as! ReimbursementViewController
        self.navigationController?.pushViewController(reimbursementViewController, animated: true)
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
        return "Transactions"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TransactionRow", forIndexPath: indexPath)
        let transaction = transactions[indexPath.item]
        
        cell.textLabel?.text = transaction.title
        cell.textLabel?.textColor = transaction.colorForStatus()
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        cell.detailTextLabel?.text = formatter.stringFromNumber(transaction.amount)
        cell.detailTextLabel?.textColor = transaction.colorForStatus()

        return cell
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
