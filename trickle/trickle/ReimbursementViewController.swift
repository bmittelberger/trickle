//
//  ReimbursementViewController.swift
//  trickle
//
//  Created by Kevin Moody on 2/4/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit
import AWSS3
import SwiftSpinner

class ReimbursementViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var PurchaseTitleTextField: UITextField!
    @IBOutlet weak var AmountTextField: UITextField!
    @IBOutlet weak var CategoryTextField: UITextField!
    @IBOutlet weak var StoreTextField: UITextField!
 
    @IBOutlet weak var DisplayImage: UIImageView!
    @IBOutlet weak var CameraButton: UIButton!
    @IBOutlet weak var CameraImageButton: UIImageView!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    
    var activeTextField: UITextField? = nil
    
    var receipt: UIImage? = nil

    @IBOutlet weak var SubmitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DisplayImage.image=UIImage(named: "receipt.jpg")
        
//        let attributes = [
//            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
//            NSFontAttributeName : UIFont(name: "Lato-Light", size: 72)! // Note the !
//        ]
//        
////        AmountTextField.attributedPlaceholder = NSAttributedString(string: "$0.00", attributes:attributes)
////        
////        AmountTextField.font = UIFont(name: "Lato-Light", size: 72)!
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == AmountTextField {
            let originalText = textField.text!
            let newString = (originalText as NSString).stringByReplacingCharactersInRange(range, withString: string) as NSString
            
            if newString == "$" || newString == "$0" {
                textField.text = ""
                return false
            }
            
            if range.length > 0 && string.isEmpty {
                return true
            }
            
            // First character, prepend a "$" and possibly a "$0"
            if textField.text!.isEmpty && !string.isEmpty {
                if string == "." {
                    textField.text = "$0."
                } else {
                    textField.text = "$\(string)"
                }
                return false
            }
            
            // Can't have two periods
            if textField.text!.containsString(".") {
                if string == "." {
                    return false
                }
                
                // Max of two characters beyond the period
                if let idx = textField.text!.characters.indexOf(".") {
                    let pos = textField.text!.startIndex.distanceTo(idx)
                    if range.location >= pos && pos <= textField.text!.characters.count - 3 {
                        return false
                    }
                }
            } else {
                // Can't add a period before 2 from the end
                if range.location <= textField.text!.characters.count - 3 {
                    return false
                }
            }
        }
        
        return true
    }
    
    func keyboardDidShow(aNotification: NSNotification) {
        let userInfo = aNotification.userInfo
        
        if let info = userInfo {
            let size = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size
            var height = size.height
            if let tabBarHeight = self.tabBarController?.tabBar.frame.height {
                height -= tabBarHeight
            }
            let contentInsets = UIEdgeInsetsMake(0, 0, height, 0)
            
            ScrollView.contentInset = contentInsets
            ScrollView.scrollIndicatorInsets = contentInsets
            
            let fieldBoundingBox = CGRectMake(activeTextField!.frame.origin.x, activeTextField!.frame.origin.y, activeTextField!.frame.width, activeTextField!.frame.height + 64 + SubmitButton.frame.height)
            
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func UploadPhoto(sender: AnyObject) {
//        let image = UIImage(named: "receipt.jpg")
//        let fileName = NSProcessInfo.processInfo().globallyUniqueString.stringByAppendingString(".png")
//        print("fileName: \(fileName)\n")
//        
//        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(fileName)
//        print("fileURL path: \(fileURL.path)\n")
//        
//        let filePath = fileURL.path!
//        let imageData = UIImagePNGRepresentation(image!)
//        imageData!.writeToFile(filePath, atomically: true)
//
//        let uploadRequest = AWSS3TransferManagerUploadRequest()
//        uploadRequest.body = fileURL
//        uploadRequest.key = "bingo"
//        uploadRequest.bucket = S3BucketName
//        
//        self.upload(uploadRequest)
//
//    }
    
    func uploadReceipt(t : Transaction){
        
        let fileName = NSProcessInfo.processInfo().globallyUniqueString.stringByAppendingString(".jpg")
        //print("fileName: \(fileName)\n")
        
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(fileName)
        //print("fileURL path: \(fileURL.path)\n")
        
        let filePath = fileURL.path!
        let imageData = UIImagePNGRepresentation(self.receipt!)
        imageData!.writeToFile(filePath, atomically: true)
        
        print("file key: \(t.imageURL)\n")
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.body = fileURL
        uploadRequest.key = t.imageURL
        uploadRequest.bucket = S3BucketName
        
        self.upload(uploadRequest)
    }
    
    func upload(uploadRequest: AWSS3TransferManagerUploadRequest) {
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        transferManager.upload(uploadRequest).continueWithBlock { (task) -> AnyObject! in
            if let error = task.error {
                if error.domain == AWSS3TransferManagerErrorDomain as String {
                    if let errorCode = AWSS3TransferManagerErrorType(rawValue: error.code) {
                        switch (errorCode) {
                        case .Cancelled, .Paused:
                            break;
                            
                        default:
                            print("upload() failed: [\(error)]")
                            break;
                        }
                    } else {
                        print("upload() failed: [\(error)]")
                    }
                } else {
                    print("upload() failed: [\(error)]")
                }
            }
            
            if let exception = task.exception {
                print("upload() failed: [\(exception)]")
            }
            return nil
        }
    }

    
    
    @IBAction func fileReimbursementRequest(sender: AnyObject) {
        PurchaseTitleTextField.resignFirstResponder()
        AmountTextField.resignFirstResponder()
        CategoryTextField.resignFirstResponder()
        StoreTextField.resignFirstResponder()
        
        if self.receipt == nil {
            Error.show("Please take a picture of your receipt.", location: self)
            return
        }
        
        if let title = PurchaseTitleTextField.text {
            if title.isEmpty {
                Error.show("Please provide a title for your purchase.", location: self)
                return
            }
            
            if var amountString = AmountTextField.text {
                if amountString.isEmpty {
                    Error.show("Please enter an amount for your purchase.", location: self)
                    return
                }
                SwiftSpinner.show("Submitting Request")
                
                if amountString.characters.first == "$" {
                    amountString.removeAtIndex(amountString.startIndex)
                }
                
                if let amount = Double.init(amountString) {
                    API.request(.POST, path: "transactions", parameters: [
                        "amount": amount,
                        "title": title,
                        "GroupId": GroupTableViewController.group.id,
                        "CreditId": CreditTransactionsTableViewController.credit.id,
                        "location" : (StoreTextField.text)!,
                        "category" : (CategoryTextField.text)!
                    ]) { (err, json) in
                        if err {
                            Error.showFromRequest(json, location: self)
                            return
                        } else {
                            let t : Transaction = Transaction.fromJSON(json["transaction"])
                            self.uploadReceipt(t)
                            SwiftSpinner.hide()
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    }
                    return
                } else {
                    Error.show("Invalid transaction amount.", location: self)
                    SwiftSpinner.hide()
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
    
//    @IBAction func BringUpCamera(sender: UIButton) {
    @IBAction func BringUpCamera(sender: UIButton) {
        PurchaseTitleTextField.resignFirstResponder()
        AmountTextField.resignFirstResponder()
        CategoryTextField.resignFirstResponder()
        StoreTextField.resignFirstResponder()
    
    
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        picker.sourceType = .Camera
        
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.receipt = image

            self.CameraButton.setTitle("Receipt Successfully Attached", forState: .Normal)
            self.CameraButton.setTitleColor(UIColor.init(red: 22 / 255.0, green: 160 / 255.0, blue: 133 / 255.0, alpha: 1), forState: .Normal)
            
            self.CameraImageButton.image = UIImage(named: "check.png")
            self.AmountTextField.becomeFirstResponder()
        }
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    

}
