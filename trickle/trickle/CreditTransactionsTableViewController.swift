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
    
    @IBOutlet var CreaditTableView: UITableView!
    
    @IBOutlet weak var CreditSegmentedControl: UISegmentedControl!
    var transactions: [Transaction] = []
    var rules : [Rule] = []
    var addButton : UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = CreditTransactionsTableViewController.credit.description
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: Selector("actionButtonPressed"))
        
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
//        self.tableView.estimatedRowHeight = 200.0;
//        self.tableView.rowHeight = 200;

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.loadTransactions()
        self.loadRules()
        self.tableView.rowHeight = 75;
    }
    
    func actionButtonPressed () {
        let optionMenu = UIAlertController(title: GroupTableViewController.group.name, message: GroupTableViewController.group.isAdmin ? "Manage Credit Line" : "Add Reimbursement Request", preferredStyle: .ActionSheet)
        
        let addReimbursementOption = UIAlertAction(title: "Submit Reimbursement Request", style: .Default, handler: addReimbursement)
        let addRuleOption = UIAlertAction(title: "Add a Rule", style: .Default, handler: addRule)
        let donateCreditOption = UIAlertAction(title: "Donate a Line of Credit", style: .Default, handler: donateLineOfCredit)
        
        let cancelActionOption = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        
        optionMenu.addAction(addReimbursementOption)
        if GroupTableViewController.group.isAdmin {
            optionMenu.addAction(addRuleOption)
            optionMenu.addAction(donateCreditOption)
        }
        optionMenu.addAction(cancelActionOption)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func addReimbursement(alert: UIAlertAction!) {
        let reimbursementViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ReimbursementViewController") as! ReimbursementViewController
        self.navigationController?.pushViewController(reimbursementViewController, animated: true)
    }
    
    func addRule(alert: UIAlertAction) {
        let ruleCreateViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RuleCreateViewController") as! RuleCreateViewController
        self.navigationController?.pushViewController(ruleCreateViewController, animated: true)
    }
    
    func donateLineOfCredit(alert: UIAlertAction) {
        let donateCreditViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DonateCreditViewController") as! DonateCreditViewController
        API.request(path: "/groups/\(GroupTableViewController.group.id)/groups") { (err, json) in
            if err {
                Error.showFromRequest(json, location: self)
                return
            }
            donateCreditViewController.subGroups = json["groups"].map { (i, group) in
                return Group.fromJSON(group)
            }
            self.navigationController?.pushViewController(donateCreditViewController, animated: true)
        }
        
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
    
    func refreshCredit() {
        API.request(path: "credits/\(CreditTransactionsTableViewController.credit.id)") { (err, json) in
            if err {
                Error.showFromRequest(json, location: self)
                return
            }
            CreditTransactionsTableViewController.credit = Credit.fromJSON(json)
        }

    }
    
    func loadRules() {
        self.rules = CreditTransactionsTableViewController.credit.rules
        self.tableView.reloadData()
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
    
    
    @IBAction func CreditSegmentedControlPressed(sender: UISegmentedControl) {
        if  CreditSegmentedControl.selectedSegmentIndex == 0 {
            self.tableView.rowHeight = 75;
            self.tableView.reloadData()
        } else {

            self.tableView.rowHeight = 160;
            self.tableView.reloadData()
            
        }
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if CreditSegmentedControl.selectedSegmentIndex == 0 {
            return "Transactions"
        } else {
            return "Rules"
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CreditSegmentedControl.selectedSegmentIndex == 0 {
            return transactions.count
        } else {
            return rules.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if CreditSegmentedControl.selectedSegmentIndex == 0 {
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
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("RuleRow", forIndexPath: indexPath) as! RuleTableViewCell
            let rule = rules[indexPath.item]
            cell.ruleStory?.attributedText = rule.ruleStory()
            return cell
        }
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if CreditSegmentedControl.selectedSegmentIndex == 0 {
            let transaction = self.transactions[indexPath.item]
            let transactionDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TransactionDetailViewController") as!TransactionDetailViewController
            API.request(path: "transactions/\(transaction.id)/") { (err, json) in
                if err {
                    Error.showFromRequest(json, location: self)
                    return
                }
                transactionDetailViewController.transaction = Transaction.fromJSON(json["transaction"])
                transactionDetailViewController.title = "Transaction Details"
                self.navigationController?.pushViewController(transactionDetailViewController, animated: true)
            }
        }
    }
    
    
    func getRuleType(rule : Rule) -> String {
        var response : String = ""
        if rule.type == Rule.RuleType.WINDOW_LIMIT {
            response = "Rate Limit"
            if rule.window == Rule.Window.DAY {
                response = "Daily " + response
            } else if rule.window == Rule.Window.WEEK {
                response = "Weekly " + response
            } else {
                response = "Monthly " + response
            }
        } else {
            response = "Single Transaction"
        }
        return response
    }
    
    func getApprovalType(rule : Rule) -> String {
        let formatter = NSNumberFormatter()
        var response : String = ""
        if rule.approval == Rule.ApprovalType.NUMBER_MEMBER {
            response = formatter.stringFromNumber(rule.threshold)!
            response += " Member"
            if rule.threshold > 1 {
                response += "s"
            }
            return response
        } else if rule.approval == Rule.ApprovalType.PERCENTAGE_MEMBER {
            response = formatter.stringFromNumber(rule.threshold)!
            response += "% of Members"
            return response
        } else if rule.approval == Rule.ApprovalType.NUMBER_ADMIN {
            response = formatter.stringFromNumber(rule.threshold)!
            response += " Admin"
            if rule.threshold > 1 {
                response += "s"
            }
            return response
        } else if rule.approval == Rule.ApprovalType.PERCENTAGE_ADMIN {
            response = formatter.stringFromNumber(rule.threshold)!
            response += "% of Admins"
            return response
        } else {
            response = "Auto Decline"
            return response
        }
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
