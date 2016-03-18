//
//  LoginViewController.swift
//  trickle
//
//  Created by Kevin Moody on 2/1/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBarHidden = true
        
        self.EmailField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    @IBAction func AttemptLogin(sender: UIButton) {
        if let email = EmailField.text {
            if let password = PasswordField.text {
                API.authenticate(email, password: password, handler: {(error, json) -> Void in
                    if !error {
                        let next = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarController") as! UITabBarController
                        
                        UIApplication.sharedApplication().delegate!.window!!.rootViewController = next
                    } else {
                        Error.showFromRequest(json, location: self)
                    }
                })
            } else {
                Error.show("Please type a password.", location: self)
            }
        } else {
            Error.show("Please type an email.", location: self)
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
