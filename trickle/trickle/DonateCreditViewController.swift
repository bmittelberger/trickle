//
//  DonateCreditViewController.swift
//  trickle
//
//  Created by Ben Mittelberger on 3/15/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

class DonateCreditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate  {

    var subGroups : [Group] = []
    
    var activeTextField: UITextField? = nil
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var availableAmountLabel: UILabel!
    @IBOutlet weak var subGroupTable: UITableView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var donateButton: UIButton!
    
    var selectedIndex : NSIndexPath? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Donate a Line of Credit"
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        self.availableAmountLabel.text = formatter.stringFromNumber(CreditTransactionsTableViewController.credit.balance)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
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
    
    @IBAction func donatePressed(sender: AnyObject) {
        let regColor: UIColor = UIColor( red: 1.0, green:  1.0, blue: 1.0, alpha: 0.0)
        self.descriptionTextField.backgroundColor = regColor
        self.amountTextField.backgroundColor = regColor

        let errorColor : UIColor = UIColor( red: 231/255.0, green: 76/255.0, blue:60/255.0, alpha: 0.3 )
        var selectedGroup : Group?
        var amount = ""
        var description = ""
        if let index = selectedIndex {
            selectedGroup = subGroups[index.item]
        } else {
            Error.show("Please Select a Subgroup.", location: self)
            return
        }
        
        if self.amountTextField.text == "" {
            self.amountTextField.backgroundColor = errorColor
            Error.show("Please Enter a Valid Amount.", location:  self)
            return
        }
        amount = self.amountTextField.text!
        
        if self.descriptionTextField.text == "" {
            self.descriptionTextField.backgroundColor = errorColor
            Error.show("Please Enter a Description.", location:  self)
            return
        }
        description = self.descriptionTextField.text!
        API.request(.POST, path: "/credits/\(CreditTransactionsTableViewController.credit.id)/credits", parameters: ["description" : description, "amount" : amount, "GroupId" : selectedGroup!.id]) { (err,json) in
            if err {
                Error.showFromRequest(json, location: self)
                return
            }
            let successAlert = UIAlertController(title: "Credit Extended", message: "You extended \(amount)$ to \(selectedGroup!.name)", preferredStyle: UIAlertControllerStyle.Alert)
            
            successAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                 self.navigationController?.popViewControllerAnimated(true)
            }))
            self.presentViewController(successAlert, animated: true, completion:  nil)
            
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath
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
