//
//  SearchViewController.swift
//  trickle
//
//  Created by Kevin Moody on 3/6/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var ResultsTableView: UITableView!
    
    var results: [Model] = []
    
    var placeholder: String = "Search"
    var searchPath: String = ""
    var resultsTransformer: ((JSON) -> [Model])? = nil
    var selectHandler: ((Model) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.SearchTextField.placeholder = self.placeholder
        self.SearchTextField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SearchTextFieldChanged(sender: AnyObject) {
        let query = SearchTextField.text!
        
        if !query.isEmpty {
            API.request(path: "\(self.searchPath)?query=\(query)") { (error, json) in
                if error {
                    Error.showFromRequest(json, location: self)
                    return
                }
                
                self.results = self.resultsTransformer!(json)
                self.ResultsTableView.reloadData()
            }
        } else {
            self.results = []
            self.ResultsTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultRow", forIndexPath: indexPath)
        cell.textLabel?.text = results[indexPath.item].displayName
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let result = results[indexPath.item]
        
        if let fn = self.selectHandler {
            fn(result)
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
