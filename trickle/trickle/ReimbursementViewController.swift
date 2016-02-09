//
//  ReimbursementViewController.swift
//  trickle
//
//  Created by Kevin Moody on 2/4/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

class ReimbursementViewController: UIViewController {
    
    @IBOutlet weak var PurchaseTitleTextField: UITextField!
    @IBOutlet weak var AmountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fileReimbursementRequest(sender: AnyObject) {
        if let title = PurchaseTitleTextField.text {
            if title.isEmpty {
                Error.show("Please provide a title for your purchase.", location: self)
                return
            }
            
            if let amountString = AmountTextField.text {
                if amountString.isEmpty {
                    Error.show("Please enter an amount for your purchase.", location: self)
                    return
                }
                
                if let amount = Double.init(amountString) {
                    API.request(.POST, path: "transactions", parameters: [
                        "amount": amount,
                        "description": title,
                        "GroupId": GroupTableViewController.group.id,
                        "CreditId": CreditTransactionsTableViewController.credit.id
                    ]) { (err, json) in
                        if err {
                            Error.showFromRequest(json, location: self)
                            return
                        }
                        
//                        let viewControllers = self.navigationController!.viewControllers
//                        if let creditTransactions = viewControllers[viewControllers.count - 2] as? CreditTransactionsTableViewController {
//                            creditTransactions.loadTransactions()
//                        }
                        
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    return
                } else {
                    Error.show("Invalid transaction amount.", location: self)
                    return
                }
            }
        }
        Error.show("Something went wrong!", location: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("this is getting called")
        if let creditTransactions = segue.destinationViewController as? CreditTransactionsTableViewController {
            print("made it")
            creditTransactions.loadTransactions()
        }
    }

}
