//
//  ReimbursementsViewController.swift
//  trickle
//
//  Created by Kevin Moody on 2/21/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

class ReimbursementsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var transactions: [Transaction] = []
    var approvals: [Approval] = []

    @IBOutlet weak var ReimbursementsSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var ReimbursementsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.ReimbursementsTableView.estimatedRowHeight = 100.0;
        self.ReimbursementsTableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadTransactions()
        self.loadApprovals()
    }
    
    func loadTransactions() {
        API.request(path: "users/me/transactions") { (err, json) in
            if err {
                Error.showFromRequest(json, location: self)
                return
            }
            
            // We have transactions to display, update the table
            self.transactions = json["transactions"].map { (i, transaction) in
                return Transaction.fromJSON(transaction)
            }
            self.ReimbursementsTableView.reloadData()
        }
    }
    
    func loadApprovals() {
        API.request(path: "users/me/approvals?statuses=ACTIVE") { (err, json) in
            if err {
                Error.showFromRequest(json, location: self)
                return
            }
            
            // We have transactions to display, update the table
            self.approvals = json["approvals"].map { (i, approval) in
                return Approval.fromJSON(approval)
            }
            self.ReimbursementsTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ReimbursementsSegmentedControlPressed(sender: AnyObject) {
        self.ReimbursementsTableView.reloadData()
        if ReimbursementsSegmentedControl.selectedSegmentIndex == 0 {
            self.loadTransactions()
        } else {
            self.loadApprovals()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ReimbursementsSegmentedControl.selectedSegmentIndex == 0 {
            return transactions.count
        } else {
            return approvals.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if ReimbursementsSegmentedControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TransactionRow", forIndexPath: indexPath)
            let transaction = transactions[indexPath.item]
            
            cell.textLabel?.text = transaction.description
            cell.textLabel?.textColor = transaction.colorForStatus()
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            cell.detailTextLabel?.text = formatter.stringFromNumber(transaction.amount)
            cell.detailTextLabel?.textColor = transaction.colorForStatus()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ApprovalRow", forIndexPath: indexPath)
            let approval = approvals[indexPath.item]
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            let amountString = formatter.stringFromNumber(approval.transaction.amount)!
            
            cell.textLabel?.text = "\(approval.transaction.user.first) \(approval.transaction.user.last) spent \(amountString). - \(approval.transaction.description)"
            cell.textLabel?.numberOfLines = 0
            
            return cell
        }
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
