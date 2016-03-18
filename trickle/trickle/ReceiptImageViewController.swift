//
//  ReceiptImageViewController.swift
//  trickle
//
//  Created by Adam on 3/15/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit
import AWSS3
import SwiftSpinner

class ReceiptImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var DisplayImage: UIImageView!
    
    var transaction : Transaction!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("transaction url: \(transaction.imageURL)")
        
        self.ScrollView.minimumZoomScale=1;
        
        self.ScrollView.maximumZoomScale=6.0;
        
        self.ScrollView.delegate=self;

        self.downloadReceiptImage()
        
        //DisplayImage.image=UIImage(named: "sunset.jpg")
        
    }

    func downloadReceiptImage(){
        let downloadingFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(transaction.imageURL)
        let downloadingFilePath = downloadingFileURL.path!
        
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest.bucket = S3BucketName
        downloadRequest.key = transaction.imageURL
        downloadRequest.downloadingFileURL = downloadingFileURL
        
        SwiftSpinner.show("Downloading Image")
        download(downloadRequest, downloadingFilePath: downloadingFilePath, count: 0)
        
        
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.DisplayImage
    }
    
    
    func download(downloadRequest : AWSS3TransferManagerDownloadRequest, downloadingFilePath : String, count : Int){
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        transferManager.download(downloadRequest).continueWithBlock({ (task) -> AnyObject! in
            if let error = task.error {
                if error.domain == AWSS3TransferManagerErrorDomain as String
                    && AWSS3TransferManagerErrorType(rawValue: error.code) == AWSS3TransferManagerErrorType.Paused {
                        print("Download paused.")
                } else {
                    if (count < 7){
                        print("here")
                        NSThread.sleepForTimeInterval(7)
                        let newCount = count + 1
                        self.download(downloadRequest, downloadingFilePath: downloadingFilePath, count: newCount)
                    } else {
                        print("download failed: [\(error)]")
                        SwiftSpinner.hide()
                        let errorAlert = UIAlertController(title: "Error", message: "Unable to load receipt.", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        errorAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                            self.navigationController?.popViewControllerAnimated(true)
                        }))
                        self.presentViewController(errorAlert, animated: true, completion:  nil)
                    }
                }
            } else if let exception = task.exception {
                print("download failed: [\(exception)]")
            } else {
                //print("path: \(downloadingFilePath)")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.DisplayImage.image = UIImage(contentsOfFile: downloadingFilePath)
//                    self.DisplayImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2));
                    SwiftSpinner.hide()
                })
            }
            return nil
        })

    }
    
}


