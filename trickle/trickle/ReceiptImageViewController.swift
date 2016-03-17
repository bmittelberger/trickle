//
//  ReceiptImageViewController.swift
//  trickle
//
//  Created by Adam on 3/15/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit
import AWSS3

class ReceiptImageViewController: UIViewController {

    @IBOutlet weak var DisplayImage: UIImageView!
    
    var transaction : Transaction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("transaction url: \(transaction.imageURL)")
        
        self.downloadReceiptImage()
        
        //DisplayImage.image=UIImage(named: "sunset.jpg")
        
    }

    func downloadReceiptImage(){
        let downloadingFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(transaction.title)
        let downloadingFilePath = downloadingFileURL.path!
        
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest.bucket = S3BucketName
        downloadRequest.key = transaction.imageURL
        downloadRequest.downloadingFileURL = downloadingFileURL
        
        
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        transferManager.download(downloadRequest).continueWithBlock({ (task) -> AnyObject! in
            if let error = task.error {
                if error.domain == AWSS3TransferManagerErrorDomain as String
                    && AWSS3TransferManagerErrorType(rawValue: error.code) == AWSS3TransferManagerErrorType.Paused {
                        print("Download paused.")
                } else {
                    print("download failed: [\(error)]")
                }
            } else if let exception = task.exception {
                print("download failed: [\(exception)]")
            } else {
                print("path: \(downloadingFilePath)")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.DisplayImage.image = UIImage(contentsOfFile: downloadingFilePath)
                })
            }
            return nil
        })

    }
    
}


