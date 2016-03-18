//
//  AppDelegate.swift
//  trickle
//
//  Created by Ben Mittelberger on 1/17/16.
//  Copyright © 2016 KAB. All rights reserved.
//

import UIKit

//extension UILabel {
//    override public func awakeFromNib() {
//        super.awakeFromNib()
//        self.font = UIFont(name: "Lato-Regular", size: (self.font?.pointSize)!)
//    }
//}
//
//extension UIButton {
//    override public func awakeFromNib() {
//        super.awakeFromNib()
//        self.titleLabel?.font = UIFont(name: "Lato-Heavy", size: (self.titleLabel?.font?.pointSize)!)
//    }
//}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var device: String = ""
    
    static let tintColor = UIColor.init(red: 0 / 255.0, green: 80 / 255.0, blue: 100 / 255.0, alpha: 1)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: CognitoRegionType, identityPoolId: CognitoIdentityPoolId)
        let configuration = AWSServiceConfiguration(region: DefaultServiceRegionType, credentialsProvider: credentialsProvider)
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
        
        UINavigationBar.appearance().barTintColor = AppDelegate.tintColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Lato-Bold", size: 18)!
        ]
        
        
        UITabBar.appearance().barTintColor = UIColor.whiteColor()
        UITabBar.appearance().tintColor = AppDelegate.tintColor
        
        UITabBarItem.appearance().setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "Lato-Regular", size: 12)!
        ], forState: UIControlState.Normal)
        
        UISegmentedControl.appearance().setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "Lato-Regular", size: 14)!
            ], forState: UIControlState.Normal)
                
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let characterSet: NSCharacterSet = NSCharacterSet(charactersInString: "<>")
        
        let deviceTokenString: String = (deviceToken.description as NSString)
            .stringByTrimmingCharactersInSet(characterSet)
            .stringByReplacingOccurrencesOfString( " ", withString: "") as String
        
        AppDelegate.device = deviceTokenString
        if User.me.id > 0 {
            User.me.syncDevice(AppDelegate.device)
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        // Fail silently
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("A -- RECEIVED NOTIFICATION!")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        if let tabBarController = self.window?.rootViewController as? UITabBarController {
            if let badgeNumber = userInfo["aps"]?["badge"] as? NSNumber {
                tabBarController.tabBar.items![1].badgeValue = badgeNumber != 0 ? "\(badgeNumber)" : nil
            }
            if application.applicationState == .Inactive || application.applicationState == .Background {
                tabBarController.selectedIndex = 1
                let reimbursementsNavigationController = tabBarController.selectedViewController! as! UINavigationController
                let reimbursementsViewController = reimbursementsNavigationController.visibleViewController as! ReimbursementsViewController
                
                dispatch_async(dispatch_get_main_queue(), {
                    reimbursementsViewController.ReimbursementsSegmentedControl?.selectedSegmentIndex = 1
                })
            }
        }
        
        completionHandler(UIBackgroundFetchResult.NoData)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        print("C -- RECEIVED NOTIFICATION!")
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

