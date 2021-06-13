//
//  AppDelegate.swift
//  Prakash
//
//  Created by Maulik Kundaliya on 04/03/20.
//  Copyright © 2020 Maulik Kundaliya. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        let dataDict:[String: String] = ["token": token]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        UserDefaults.standard.setValue(fcmToken, forKey: "fcmToken")
        Messaging.messaging().apnsToken = token.data(using: .utf8)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo as NSDictionary
        print(userInfo)
        let typeValue = userInfo.stringValueForKey("type")
        UserDefaults.standard.setValue(typeValue, forKey: "NotificationType")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeVC.isFromNotification = true
        appDelegate.window?.rootViewController = UINavigationController(rootViewController: homeVC)
        print(userInfo)
    }
    
    func stringValueForKey(dict: [AnyHashable : Any],_ key : String) -> String {
        var str_value_to_return = ""
        if let int64_value        = dict[key] as? Int64{
            str_value_to_return   =  String(int64_value)
        }else if let string_value = dict[key] as? String {
            str_value_to_return   =  string_value
        }else if let number_value =  dict[key] as? NSNumber {
            str_value_to_return   =  number_value.stringValue
        }
        return str_value_to_return
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        let typeValue = stringValueForKey(dict: userInfo, "type")
        UserDefaults.standard.setValue(typeValue, forKey: "NotificationType")
        
        homeVC.isFromNotification = true
        appDelegate.window?.rootViewController = UINavigationController(rootViewController: homeVC)
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print(NSString(data: deviceToken, encoding: String.Encoding.utf8.rawValue))
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
        
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
    
    func configNotification() {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { granted, error in
                  print("Permission granted: \(granted)")
                  // 1. Check if permission granted
                  guard granted else { return }
                  // 2. Attempt registration for remote notifications on the main thread
                  DispatchQueue.main.async {
                      UIApplication.shared.registerForRemoteNotifications()
                  }
          })
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configNotification()
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = UIColor.red//(red: 234.0/255.0, green: 46.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
//        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.6))
//        Thread.sleep(forTimeInterval: 1.6)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let homeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
//        window?.rootViewController = UINavigationController(rootViewController: homeVC)
        IQKeyboardManager.shared.enable = true  
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension NSDictionary {
    func stringValueForKey(_ key : String) -> String {
        var str_value_to_return = ""
        if let int64_value        = self[key] as? Int64{
            str_value_to_return   =  String(int64_value)
        }else if let string_value = self[key] as? String {
            str_value_to_return   =  string_value
        }else if let number_value =  self[key] as? NSNumber {
            str_value_to_return   =  number_value.stringValue
        }
        return str_value_to_return
    }

}
