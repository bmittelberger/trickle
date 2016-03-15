//
//  TransactionDetailViewController.swift
//  trickle
//
//  Created by Ben Mittelberger on 3/7/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

extension String {
    func indexOf(string: String) -> String.Index? {
        return rangeOfString(string, options: .LiteralSearch, range: nil, locale: nil)?.startIndex
    }
    
//    func getRange(string: String, rangeForString: String) -> Range<String.CharacterView.Index> {
//        let start = string.indexOf(rangeForString)!
//        let range = string.start..<string.startIndex.advancedBy(2)
//        return range
//    }
}

    

class TransactionDetailViewController: UIViewController {
    


    var transaction : Transaction?
    
    @IBOutlet weak var transactionCategory: UILabel!
    @IBOutlet weak var transactionLocation: UILabel!
    @IBOutlet weak var transactionStatus: UILabel!
    @IBOutlet weak var transactionStory: UILabel!
    @IBOutlet weak var groupCreditStory: UILabel!
    @IBOutlet weak var ruleStory: UILabel!
    @IBOutlet weak var currentRuleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        

        
        transactionStory.attributedText = transaction!.transactionStory()
        groupCreditStory.attributedText = transaction!.creditStory()
        let ruleJSON = transaction?.stateInfo["currentState"]["currentRule"]
        if ruleJSON?.rawString() != "null" {
            let currentRule = Rule.fromJSON(ruleJSON!)
            ruleStory.attributedText = currentRule.ruleStory()
        } else {
            currentRuleLabel.text = "No Pending Rules."
            ruleStory.text = ""
        }
        
        let pendingColor: UIColor = UIColor( red: 241/255, green:  196/255, blue: 15/255, alpha: 0.9)
        let declinedColor: UIColor = UIColor( red: 231/255, green:  76/255, blue: 60/255, alpha: 0.9)
        let approvedColor: UIColor = UIColor( red: 39/255, green:  174/255, blue: 96/255, alpha: 0.9)
        if (transaction?.status == Transaction.Status.Pending) {
            transactionStatus.text = "PENDING"
            transactionStatus.textColor = pendingColor
        } else if (transaction?.status == Transaction.Status.Declined) {
            transactionStatus.text = "DECLINED"
            transactionStatus.textColor = declinedColor
        } else {
            transactionStatus.text = "APPROVED"
            transactionStatus.textColor = approvedColor
        }
        if let categoryText = self.transaction?.category {
            transactionCategory.text = categoryText
        } else {
            transactionCategory.text = "None Given"
        }
        if let locationText = self.transaction?.location {
            transactionLocation.text = locationText
        } else {
            transactionLocation.text = "None Given"
        }
        
        transactionCategory.sizeToFit()
        transactionLocation.sizeToFit()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
