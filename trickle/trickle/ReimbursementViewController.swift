//
//  ReimbursementViewController.swift
//  trickle
//
//  Created by Kevin Moody on 2/4/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit
import AWSS3

class ReimbursementViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var PurchaseTitleTextField: UITextField!
    @IBOutlet weak var AmountTextField: UITextField!
    @IBOutlet weak var CategoryTextField: UITextField!
    @IBOutlet weak var StoreTextField: UITextField!
    @IBOutlet weak var UploadPhotoButton: UIButton!

//    @IBOutlet weak var CameraButton: UIButton!
//    @IBOutlet weak var DisplayImage: UIImageView!
 
    @IBOutlet weak var DisplayImage: UIImageView!
    @IBOutlet weak var CameraButton: UIButton!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    var activeTextField: UITextField? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DisplayImage.image=UIImage(named: "receipt.jpg")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func UploadPhoto(sender: AnyObject) {
        let image = UIImage(named: "receipt.jpg")
        let fileName = NSProcessInfo.processInfo().globallyUniqueString.stringByAppendingString(".png")
        print("fileName: \(fileName)\n")
        
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(fileName)
        print("fileURL path: \(fileURL.path)\n")
        
        let filePath = fileURL.path!
        let imageData = UIImagePNGRepresentation(image!)
        imageData!.writeToFile(filePath, atomically: true)

        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.body = fileURL
        uploadRequest.key = "bingo"
        uploadRequest.bucket = S3BucketName
        
        self.upload(uploadRequest)

    }
    
    func uploadReceipt(){
        let image = UIImage(named: "receipt.jpg")
        let fileName = NSProcessInfo.processInfo().globallyUniqueString.stringByAppendingString(".png")
        print("fileName: \(fileName)\n")
        
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(fileName)
        print("fileURL path: \(fileURL.path)\n")
        
        let filePath = fileURL.path!
        let imageData = UIImagePNGRepresentation(image!)
        imageData!.writeToFile(filePath, atomically: true)
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.body = fileURL
        uploadRequest.key = PurchaseTitleTextField.text
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
        if DisplayImage.image == nil {
            print("Shit is nil brah")
        } else {
            print("we good")
        }
        
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
                        "title": title,
                        "GroupId": GroupTableViewController.group.id,
                        "CreditId": CreditTransactionsTableViewController.credit.id,
                        "location" : (StoreTextField.text)!,
                        "category" : (CategoryTextField.text)!
                    ]) { (err, json) in
                        if err {
                            print("here 1")
                            Error.showFromRequest(json, location: self)
                            return
                        }
                        
                        //self.uploadReceipt()
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
    
//    @IBAction func BringUpCamera(sender: UIButton) {
    @IBAction func BringUpCamera(sender: UIButton) {
    
    
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        picker.sourceType = .Camera
        
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        DisplayImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage; dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    
    

}
