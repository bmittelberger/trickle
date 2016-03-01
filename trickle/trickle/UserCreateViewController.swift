//
//  UserCreateViewController.swift
//  trickle
//
//  Created by Ben Mittelberger on 2/28/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

class UserCreateViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var venmoPhoneTextField: UITextField!
    
    static var currentPassword = ""
    
    @IBOutlet weak var createButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "SelectOrganizationSegue" {
            
            let regColor : UIColor = UIColor( red: 1.0, green:  1.0, blue: 1.0, alpha: 0.0)
            emailTextField.backgroundColor = regColor
            passwordTextField.backgroundColor = regColor
            firstNameTextField.backgroundColor = regColor
            lastNameTextField.backgroundColor = regColor
            venmoPhoneTextField.backgroundColor = regColor
            
            var anyBadInputs : Bool = false
            let errorColor : UIColor = UIColor( red: 231/255.0, green: 76/255.0, blue:60/255.0, alpha: 0.3 )
            if "" == emailTextField.text {
                emailTextField.backgroundColor = errorColor
                anyBadInputs = true
            }
            if "" == passwordTextField.text {
                passwordTextField.backgroundColor = errorColor
                anyBadInputs = true
            }
            if "" == firstNameTextField.text {
                firstNameTextField.backgroundColor = errorColor
                anyBadInputs = true
            }
            if "" == lastNameTextField.text {
                lastNameTextField.backgroundColor = errorColor
                anyBadInputs = true
            }
            if "" == venmoPhoneTextField.text {
                venmoPhoneTextField.backgroundColor = errorColor
                anyBadInputs = true
            }
            if anyBadInputs {
                Error.show("Please fix highlighted fields.", location:  self)
                return false
            }
            
            User.me.email = emailTextField.text!
            UserCreateViewController.currentPassword = passwordTextField.text!
            User.me.first = firstNameTextField.text!
            User.me.last = lastNameTextField.text!
        }
        
        // by default, transition
        return true
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
