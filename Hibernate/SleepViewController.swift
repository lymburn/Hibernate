//
//  SleepViewController.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-05-01.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation

class SleepViewController: UIViewController {
    let dateFormatter = DateFormatter()
    var timer = Timer()
    var changeViewTimer = Timer()
    let fadeTransition = FadeAnimator()
    let notificationCenter = UNUserNotificationCenter.current()
    var wakeUpDate : Date!
    var audioManager = AudioManager()

    @IBOutlet weak var wakingTimeLabel: UILabel! {
        didSet {
            wakingTimeLabel.text! = "Waking at " + dateFormatter.string(from: wakeUpDate)
            wakingTimeLabel.alpha = 0
        }
    }
    
    @IBAction func stopSleepingButton(_ sender: UIButton) {
    }
    
    @IBOutlet weak var stopSleepingButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel! {
        didSet {
            currentTimeLabel.alpha = 0
            dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm a")
            let current = Date()
            currentTimeLabel.text! = dateFormatter.string(from: current)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserDefaults.standard.bool(forKey: "alarmOn")) {
            scheduleNotification(secondOffset: 0, identifier: "firstAlarmNotification", includeBanner: true)
            scheduleNotification(secondOffset: 30, identifier: "secondAlarmNotification", includeBanner: false)
            scheduleNotification(secondOffset: 59, identifier: "thirdAlarmNotification", includeBanner: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateCurrentTime()
        changeViewAfterWakeUpTime()
        if (UserDefaults.standard.bool(forKey: "sleepAidOn")) {
            audioManager.playSleepMusic(songName: "Closer", loops: 3)
        }
        //Fade in labels
        UIView.animate(withDuration: 2, animations: {()->Void in
            self.currentTimeLabel.alpha = 1
            self.wakingTimeLabel.alpha = 1
        }, completion: nil)
    }
    
    private func updateCurrentTime() {
        //Run timer to update current time every second
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {(timer)->Void in
            let currentTime = Date()
            self.currentTimeLabel.text! = self.dateFormatter.string(from: currentTime)
        })
    }
    
    private func changeViewAfterWakeUpTime() {
        //Run timer to check if the current time is past the wake up time and change views if so
        changeViewTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {(timer)->Void in
            let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
            let currentDate = Calendar.current.date(from: currentDateComponents)
            let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self.wakeUpDate)
            let triggerDate = Calendar.current.date(from: triggerDateComponents)
            
            //If current date is greater than wake up date, change to next view
            if (currentDate! >= triggerDate!) {
                //Turn off further notifications
                self.notificationCenter.removeAllPendingNotificationRequests()
                //Turn off sleep aid music
                self.audioManager.stopPlayingMusic()
                //Transition to starting view controller
                UIView.animate(withDuration: 0.5, animations: {()->Void in
                    self.wakingTimeLabel.transform = CGAffineTransform(translationX: 0, y: -50)
                    self.currentTimeLabel.transform = CGAffineTransform(translationX: 0, y: -50)
                    self.stopSleepingButton.transform = CGAffineTransform(translationX: 0, y: 50)
                    self.wakingTimeLabel.alpha = 0
                    self.currentTimeLabel.alpha = 0
                    self.stopSleepingButton.alpha = 0
                })
                
                let wakeUp = self.storyboard!.instantiateViewController(withIdentifier: "StartViewController") as! StartViewController
                wakeUp.transitioningDelegate = self
                self.present(wakeUp, animated: false, completion: nil)
                self.changeViewTimer.invalidate()
            }
        })
    }
    
    //Schedule alarm notification
    private func scheduleNotification(secondOffset : Int, identifier : String, includeBanner : Bool) {
        let content = UNMutableNotificationContent()
        if (includeBanner) {
            content.title = "Good morning"
            content.body = "Enjoy the day"
        }
        
        var alarmSoundName = UserDefaults.standard.string(forKey: "alarmSound")
        alarmSoundName! += ".mp3"
        content.sound = UNNotificationSound(named: alarmSoundName!)
        
        //Set date so that notification plays every 30 seconds
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: wakeUpDate)
        var scheduledWakeUpDate = Calendar.current.date(from: components)
        scheduledWakeUpDate = Calendar.current.date(bySetting: .second, value: secondOffset, of: scheduledWakeUpDate!)
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: scheduledWakeUpDate!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.delegate = self
        notificationCenter.add(request, withCompletionHandler: {(error) in
            if let error = error {
                print (error.localizedDescription)
            }
        })
    }
}

extension SleepViewController: UNUserNotificationCenterDelegate, UIViewControllerTransitioningDelegate {
    //Controls what happens when alarm occurs in foreground
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    //Controls what happens when alarm occurs elsewhere
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        completionHandler()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //Decide whether to return a custom animation
        return fadeTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //Deal with dismissing view controllers
        return nil
    }
}
