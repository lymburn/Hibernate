//
//  AppDelegate.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-04-29.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation
import AudioToolbox
import PMAlertController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    //Manage notifications
    let notificationCenter = UNUserNotificationCenter.current()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        chooseStoryboard()
        // Override point for customization after application launch.
        requestNotifications()
        enableBackgroundAudioMode()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        //Set default settings if app hasn't been launched before
        if (!launchedBefore) {
            print("did not launch before")
            setDefaultSettings()
        }
        UIApplication.shared.statusBarStyle = .lightContent
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
    
    func requestNotifications() {
        //Ask for notification requests
        let options: UNAuthorizationOptions = [.alert, .sound]
        notificationCenter.requestAuthorization(options: options) { (granted, error) in
            if !granted {
            
            }
        }
    }
    
    func enableBackgroundAudioMode() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print ("audio session failed")
        }
    }
    
    func chooseStoryboard() {
        var storyboard: UIStoryboard!
        let device = UIDevice.current.userInterfaceIdiom
        if device == .pad {
            storyboard = UIStoryboard(name: "iPad", bundle: nil)
        } else {
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        }
        let userIsSleeping = UserDefaults.standard.bool(forKey: "sleeping")
        //If user is sleeping, set initial view controller to sleep view controller. Else, start.
        var initialVC : UIViewController!
        if userIsSleeping {
            initialVC = storyboard.instantiateViewController(withIdentifier: "SleepViewController") as! SleepViewController
        } else {
            initialVC = storyboard.instantiateViewController(withIdentifier: "StartViewController") as! StartViewController
        }
        
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
    }
    
    //Set user default settings for the first time
    private func setDefaultSettings() {
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        UserDefaults.standard.register(defaults: ["alarmOn" : true])
        UserDefaults.standard.register(defaults: ["sleepAidOn" : true])
        UserDefaults.standard.register(defaults: ["alarmSound" : "Summer"])
        UserDefaults.standard.register(defaults: ["sleepSound" : "Light Rain"])
        UserDefaults.standard.register(defaults: ["sleepAidDuration" : 30])
        let initialWakeUpDate = Date()
        UserDefaults.standard.register(defaults: ["wakeUpDate" : initialWakeUpDate])
        UserDefaults.standard.register(defaults: ["premiumOn" : false])
    }
}

