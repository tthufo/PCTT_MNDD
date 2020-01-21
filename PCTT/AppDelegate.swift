//
//  AppDelegate.swift
//  PCTT
//
//  Created by Thanh Hai Tran on 8/3/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

import UIKit
import GoogleMaps
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let APIMAP: String = "AIzaSyBXBWoCCozdvmjRABdP_VfDiPAsSU1WS2Q" //"AIzaSyBpY_YNBDcSSQn_RN9aaR1uzHRT3BHl_Q0"//
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey(APIMAP)
        
//        FirePush.shareInstance().didRegister()

//        if self.getValue("push") == "0" {
    ////            FirePush.shareInstance()?.didUnregisterNotification()
//        }
        
        if self.getValue("push") == nil {
            self.addValue("1", andKey: "push")
        //            FirePush.shareInstance()?.didUnregisterNotification()
        }
        
//        self.remove("offline")
        
        if self.getObject("offline") == nil {
            self.add(["data": NSMutableArray()], andKey: "offline")
        }
        
        print(self.getObject("offline"))
        
        if self.getValue("autoId") == nil {
            self.addValue("1", andKey: "autoId")
        }
        
        Information.saveToken()
        
        Information.saveInfo()
        
        Information.saveBG()
        
        Information.saveOffline()

        
        LTRequest.sharedInstance().initRequest()

        self.customTab()

//        UITabBar.appearance().tintColor = UIColor(red: 232/255.0, green: 125/255.0, blue: 0/255.0, alpha: 1.0)

        UITabBar.appearance().barTintColor = UIColor(red: 0/255.0, green: 100/255.0, blue: 225/255.0, alpha: 1.0)

        let login = PC_Login_ViewController.init()
        
        let nav = UINavigationController.init(rootViewController: login)

        nav.isNavigationBarHidden =  
        
        ((self.window?.rootViewController = nav) != nil)
        
        self.window?.makeKeyAndVisible()

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        FirePush.shareInstance()?.didReiciveToken(deviceToken, withType: 0)
//        self.addValue("1", andKey: "push")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        FirePush.shareInstance()?.didFailedRegisterNotification(error)
//        self.addValue("0", andKey: "push")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
//        if application.applicationState == .background || application.applicationState == .inactive {
//            if let customData = (userInfo as NSDictionary)["custom_key"] {
//                if let stationCode = ((customData as! NSString).objectFromJSONString() as! NSDictionary).getValueFromKey("station_code") {
//                    let foreCast = PC_ForCast_ViewController.init()
//
//                    foreCast.stationCode = ((customData as! NSString).objectFromJSONString() as! NSDictionary).getValueFromKey("station_code") as NSString?
//
//                    foreCast.station = ((customData as! NSString).objectFromJSONString() as! NSDictionary).getValueFromKey("station_name") as NSString?
//                    let logged = Information.token != nil && Information.token != ""
//                    if logged {
//                        (root() as! UINavigationController).present(foreCast, animated: true) {
//
//                        }
//                    }
//                }
//            }
//        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
//        FirePush.shareInstance()?.disconnectToFcm()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//        FirePush.shareInstance()?.connectToFcm()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
