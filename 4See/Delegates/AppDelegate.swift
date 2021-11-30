//
//  AppDelegate.swift
//  4See
//
//  Created by Gagan Arora on 03/03/21.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import Firebase
import UserNotifications
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {
    var window: UIWindow?
    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 3.0)
        IQKeyboardManager.shared.enable = true
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        autoLogin()
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        registerUserNotificationSettings(application: application)
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                // self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
            }
        }
        return true
    }
    func handleEvent(for region: CLRegion!) {
        // Show an alert if application is active
        if UIApplication.shared.applicationState == .active {
            let message = region.identifier
            window?.rootViewController?.showAlert(title: nil, message: message)
        } else {
            // Otherwise present a local notification
            let notificationContent = UNMutableNotificationContent()
            notificationContent.body = "Geofence triggered!"
            notificationContent.sound = UNNotificationSound.default
            notificationContent.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "geofenceId",
                                                content: notificationContent,
                                                trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func autoLogin()
    {
        if(UserDefaults.standard.bool(forKey: "USERISLOGIN") == true){
            let objLogoutVC = HomeViewController()
            let navigationController = UINavigationController(rootViewController: objLogoutVC)
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.isHidden = true
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let objLogoutVC = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! loginViewController
            let navigationController = UINavigationController(rootViewController: objLogoutVC)
            
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.isHidden = true
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
    }
    func registerUserNotificationSettings(application: UIApplication) {
        if #available(iOS 14.0, *)
        {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        application.applicationIconBadgeNumber = 0
        application.registerForRemoteNotifications()
    }
    // MARK: - Firebase Methods.
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String!)
    {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        UserDefaults.standard.setValue(fcmToken, forKey: "fcmToken")
        AppConfig.deviceToken = fcmToken
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken
        // Pass device token to auth.
        let firebaseAuth = Auth.auth()
        //At development time we use .sandbox
        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
        //  Auth.auth().setAPNSToken(deviceToken, type: .prod)
        let  devicetoken  = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Device Token : ",devicetoken)
        //            AppConfig.deviceToken = devicetoken
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        } else {
            return false
        }
    }
    
    @available(iOS 10.0, *)
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        
        if Auth.auth().canHandleNotification(notification)
        {
            completionHandler(.noData)
            print(notification.values)
            
            return
        }
        print(notification.values)
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // Print full message.
        print(userInfo)
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let message = alert["message"] as? NSString {
                    //Do stuff
                    let messageResp = message
                    print(messageResp)
                }
            } else if let alert = aps["alert"] as? NSString {
                //Do stuff
                let Resp = alert
                print(Resp)
            }
        }
        
        completionHandler(UNNotificationPresentationOptions.alert)
        // Change this to your preferred presentation option
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        let apsdata = userInfo[AnyHashable("aps")] as! NSDictionary
        print(apsdata as Any)
        //                let apssdata = userInfo[AnyHashable("type")] as! String
        //                print(apssdata as Any)
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "notificationData"), object: nil, userInfo: userInfo as? [AnyHashable : Any])
        
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
}
 
extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(for: region)
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(for: region)
        }
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?,
    withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }

}
