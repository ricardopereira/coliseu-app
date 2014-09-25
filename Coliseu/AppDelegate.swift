//
//  AppDelegate.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 22/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    var appCtrl = AppController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        // UITabBarController or UINavigationController or UISplitViewController
        navigationController = UINavigationController()
        navigationController!.navigationBar.translucent = false
        navigationController!.navigationBarHidden = true

        // Root view
        let mainView = MainViewController(nibName: "MainView", appCtrl: appCtrl)
        mainView.edgesForExtendedLayout = UIRectEdge.None
        mainView.extendedLayoutIncludesOpaqueBars = false

        navigationController!.pushViewController(mainView, animated: false)

        // Assign root
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = UIColor.whiteColor()
        window!.makeKeyAndVisible()
        window!.rootViewController = navigationController

        // Push Notifications
        UIApplication.sharedApplication().registerForRemoteNotifications()

        // Custom push
        let settings = UIUserNotificationSettings(forTypes: .Alert | .Badge, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)

        //userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        return true
    }

    func applicationWillTerminate(application: UIApplication)
    {
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!)
    {
        // Device token
        var characterSet: NSCharacterSet = NSCharacterSet(charactersInString: "<>")
        // Translate
        var deviceTokenString: String = (deviceToken.description as NSString)
            .stringByTrimmingCharactersInSet(characterSet)
            .stringByReplacingOccurrencesOfString(" ", withString: "") as String
        // Assign to Root
        appCtrl.data.deviceToken = deviceTokenString
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError!)
    {
        println("Couldn't register: \(error)")
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    {
        // If the app is running, the app calls this method to process incoming remote notifications
        NSLog("didReceiveRemoteNotification")

        if let title: AnyObject = userInfo["title"] {
            if let fileName: AnyObject = userInfo["filename"] {
                // New notification
                handleNotification(application.applicationState, title as String, fileName as String)
                completionHandler(UIBackgroundFetchResult.NewData)
                return
            }
        }
        completionHandler(UIBackgroundFetchResult.NoData)
    }

    func applicationDidBecomeActive(application: UIApplication)
    {
        // Remover as notificações
        application.applicationIconBadgeNumber = 0
    }

    func handleNotification(state: UIApplicationState, _ title: String, _ fileName: String)
    {
        switch state {
        case UIApplicationState.Active:
            // Application is running in foreground
            NSLog("Foreground notification")
        case UIApplicationState.Background, UIApplicationState.Inactive:
            // Application is brought from background or launched after terminated
            handleNotification(UIApplicationState.Active,title,fileName)
        }
    }

}
