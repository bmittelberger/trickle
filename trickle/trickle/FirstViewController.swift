//
//  FirstViewController.swift
//  trickle
//
//  Created by Ben Mittelberger on 1/17/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var WelcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        WelcomeLabel.text = "Hi, " + User.me.first + "!"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

