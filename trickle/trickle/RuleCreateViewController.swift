//
//  RuleCreateViewController.swift
//  trickle
//
//  Created by Ben Mittelberger on 3/6/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit
import SwiftyJSON

class RuleCreateViewController: UIViewController, SSRadioButtonControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var rateLimit: UIButton!
    @IBOutlet weak var rangeLimit: UIButton!
    var transactionTypeController: SSRadioButtonsController?
    
    var activeTextField: UITextField? = nil
    
    @IBOutlet weak var windowDailyButton: UIButton!
    @IBOutlet weak var windowWeeklyButton: UIButton!
    @IBOutlet weak var windowMonthlyButton: UIButton!
    var windowSizeController: SSRadioButtonsController?
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var adminApprovalButton: UIButton!
    @IBOutlet weak var memberApprovalButton: UIButton!
    var approvalController: SSRadioButtonsController?
    
    @IBOutlet weak var minTextField: UITextField!
    @IBOutlet weak var maxTextField: UITextField!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var percentageButton: UIButton!
    @IBOutlet weak var numberButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    var thresholdController: SSRadioButtonsController?

    @IBOutlet weak var thresholdTextInputLabel: UILabel!
    @IBOutlet weak var thresholdTextField: UITextField!
    @IBOutlet weak var thresholdUnit: UILabel!
    
    @IBOutlet weak var addRuleButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create A New Rule"
        transactionTypeController = SSRadioButtonsController(buttons: rateLimit, rangeLimit)
        rateLimit.selected = true
        transactionTypeController!.delegate = self
        transactionTypeController!.shouldLetDeSelect = false
        transactionTypeController?.selectFirstElement()

        windowSizeController = SSRadioButtonsController(buttons: windowDailyButton, windowWeeklyButton, windowMonthlyButton)
        windowSizeController!.delegate = self
        windowSizeController!.shouldLetDeSelect = false
        windowDailyButton.selected = true
        windowSizeController?.selectFirstElement()
        
        
        approvalController = SSRadioButtonsController(buttons: adminApprovalButton, memberApprovalButton)
        approvalController!.delegate = self
        approvalController!.shouldLetDeSelect = false
        adminApprovalButton.selected = true
        approvalController?.selectFirstElement()

        
        thresholdController = SSRadioButtonsController(buttons: numberButton, percentageButton, declineButton)
        thresholdController!.delegate = self
        thresholdController!.shouldLetDeSelect = false
        numberButton.selected = true
        thresholdController?.selectFirstElement()
        thresholdUnit.text = ""
        thresholdTextInputLabel.text = "Number of Users"
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func didSelectButton(pressed: UIButton?) {
        if transactionTypeController!.selectedButton() == rateLimit && pressed == rateLimit{
            windowDailyButton.enabled = true
            windowWeeklyButton.enabled = true
            windowMonthlyButton.enabled = true
            windowDailyButton.selected = true
            rateLabel.textColor = UIColor.blackColor()
        } else if transactionTypeController!.selectedButton() == rangeLimit && pressed == rangeLimit {
            windowDailyButton.enabled = false
            windowWeeklyButton.enabled = false
            windowMonthlyButton.enabled = false
            windowDailyButton.selected = false
            windowWeeklyButton.selected = false
            windowMonthlyButton.selected = false
            rateLabel.textColor = UIColor.grayColor()
        }
        if pressed == numberButton {
            thresholdTextInputLabel.text = "Number of Users"
            thresholdUnit.text = ""
            adminApprovalButton.enabled = true
            memberApprovalButton.enabled = true
            thresholdTextField.enabled = true
        } else if pressed == percentageButton {
            thresholdTextInputLabel.text = "Percent of Users"
            thresholdUnit.text = "%"
            adminApprovalButton.enabled = true
            memberApprovalButton.enabled = true
            thresholdTextField.enabled = true
        } else if pressed == declineButton {
            thresholdTextInputLabel.text = "Auto-Decline"
            adminApprovalButton.enabled = false
            memberApprovalButton.enabled = false
            thresholdTextField.enabled = false
        }
    }
    
    func extractRule() -> Rule {
        let newRule = Rule()
        
        if transactionTypeController!.selectedButton() == rateLimit {
            newRule.type = Rule.RuleType.WINDOW_LIMIT
            if windowSizeController?.selectedButton() == windowDailyButton {
                newRule.window = Rule.Window.DAY
            } else  if windowSizeController?.selectedButton() == windowWeeklyButton {
                newRule.window = Rule.Window.WEEK
            } else {
                newRule.window = Rule.Window.MONTH
            }
        } else if transactionTypeController!.selectedButton() == rangeLimit {
            newRule.type = Rule.RuleType.RANGE_APPROVAL
            newRule.window = ""
        }
        newRule.min =  Float(minTextField.text!)!
        if maxTextField.text == "" {
            newRule.max = -1
        } else {
            newRule.max = Float(maxTextField.text!)!
        }
        let percent = thresholdController!.selectedButton() == percentageButton
        
        if approvalController!.selectedButton() == adminApprovalButton {
            if percent {
                newRule.approval = Rule.ApprovalType.PERCENTAGE_ADMIN
            } else {
                newRule.approval = Rule.ApprovalType.NUMBER_ADMIN
            }
        } else if approvalController!.selectedButton() == memberApprovalButton {
            if percent {
                newRule.approval = Rule.ApprovalType.PERCENTAGE_MEMBER
            } else {
                newRule.approval = Rule.ApprovalType.NUMBER_MEMBER
            }
        }
        if thresholdController!.selectedButton() == declineButton {
            newRule.approval = Rule.ApprovalType.DECLINE
        }
        newRule.side = Rule.CreditSide.RECEIVER
        if newRule.approval != Rule.ApprovalType.DECLINE {
            newRule.threshold = Int(thresholdTextField.text!)!
        } else {
            newRule.threshold = -1
        }
        

        
        return newRule
    }
    
    @IBAction func addRule(sender: UIButton) {
        let regColor : UIColor = UIColor( red: 1.0, green:  1.0, blue: 1.0, alpha: 0.0)
        let errorColor : UIColor = UIColor( red: 231/255.0, green: 76/255.0, blue:60/255.0, alpha: 0.3 )
        minTextField.backgroundColor = regColor
        thresholdTextField.backgroundColor = regColor
        
        var message = ""
        var emptyThreshold : Bool = false
        var badInputs : Bool = false
        if "" == minTextField.text {
            minTextField.backgroundColor = errorColor
            message += "Please Enter a Min Value.\n"
            badInputs = true
        }
        if "" == thresholdTextField.text && thresholdController?.selectedButton() != declineButton{
            thresholdTextField.backgroundColor = errorColor
            message += "Please enter a "
            if thresholdController?.selectedButton() == percentageButton {
                message += "percentage of users.\n"
            } else {
                message += "number of users.\n"
            }
            badInputs = true
            emptyThreshold = true
        }
        let percent = Int(thresholdTextField.text!)
        if !emptyThreshold && thresholdController?.selectedButton() == percentageButton && (percent > 100 || percent == 0) {
            thresholdTextField.backgroundColor = errorColor
            message += "Invalid Percentage of members.\n"
            badInputs = true
        }
        if badInputs {
            Error.show(message, location: self)
            return
        }
        let newRule = extractRule()
        let credit = CreditTransactionsTableViewController.credit
        var rules = credit.rules
        rules.append(newRule)
        let jsonList = rules.map({rule in
            return Rule.toJSON(rule)
        })
        let rulesJSON = JSON(jsonList)
        API.request(.PUT, path: "/credits/\(credit.id)/", parameters: ["rules" : rulesJSON.rawString()!]) { (err, json) in
            if err {
                Error.showFromRequest(json, location: self)
                return
            }
            CreditTransactionsTableViewController.credit.rules.append(Rule.fromJSON(Rule.toJSON(newRule)))
            CreditTransactionsTableViewController.credit.rules.sortInPlace({$0.min < $1.min})
            self.navigationController?.popViewControllerAnimated(true)
        }
       
    }
    
    func keyboardDidShow(aNotification: NSNotification) {
        let userInfo = aNotification.userInfo
        
        if let info = userInfo {
            let size = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size
            let contentInsets = UIEdgeInsetsMake(0, 0, size.height, 0)
            
            ScrollView.contentInset = contentInsets
            ScrollView.scrollIndicatorInsets = contentInsets
            
            let fieldBoundingBox = CGRectMake(activeTextField!.frame.origin.x, activeTextField!.frame.origin.y, activeTextField!.frame.width, activeTextField!.frame.height + 16)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.ScrollView.scrollRectToVisible(fieldBoundingBox, animated: true)
            })
        }
    }
    
    func keyboardWillHide(aNotification: NSNotification) {
        let defaultInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        ScrollView.contentInset = defaultInsets
        ScrollView.scrollIndicatorInsets = defaultInsets
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let view = segue.destinationViewController as? CreditTransactionsTableViewController {
            view.loadRules()
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
