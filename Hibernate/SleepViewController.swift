//
//  SleepViewController.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-05-01.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import UIKit
import UserNotifications

class SleepViewController: UIViewController {
    let dateFormatter = DateFormatter()
    var timer = Timer()
    var changeViewTimer = Timer()
    let fadeTransition = FadeAnimator()
    let notificationCenter = UNUserNotificationCenter.current()
    var wakeUpDate : Date!

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
        //scheduleNotification()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateCurrentTime()
        changeViewAfterWakeUpTime()
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
            let currentDateComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
            let currentDate = Calendar.current.date(from: currentDateComponents)
            let triggerDateComponents = Calendar.current.dateComponents([.hour, .minute], from: self.wakeUpDate)
            let triggerDate = Calendar.current.date(from: triggerDateComponents)
            
            //If current date is greater than wake up date, change to next view
            if (currentDate! >= triggerDate!) {
                let wakeUp = self.storyboard!.instantiateViewController(withIdentifier: "WakeUpViewController") as! WakeUpViewController
                wakeUp.transitioningDelegate = self
                self.present(wakeUp, animated: true, completion: nil)
                self.changeViewTimer.invalidate()
            }
        })
    }
    
    //Schedule alarm notification
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Good morning"
        content.body = "Enjoy the day"
        content.sound = UNNotificationSound.default()
        
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: wakeUpDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let identifier = "AlarmNotification"
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
        //Hide labels and show wake up labels
        UIView.animate(withDuration: 0.5, animations: {()->Void in
            self.wakingTimeLabel.transform = CGAffineTransform(translationX: 0, y: -50)
            self.currentTimeLabel.transform = CGAffineTransform(translationX: 0, y: -50)
            self.stopSleepingButton.transform = CGAffineTransform(translationX: 0, y: 50)
            self.wakingTimeLabel.alpha = 0
            self.currentTimeLabel.alpha = 0
            self.stopSleepingButton.alpha = 0
            
            //Transition to wake up screen
            let wakeUp = self.storyboard!.instantiateViewController(withIdentifier: "WakeUpViewController") as! WakeUpViewController
            wakeUp.transitioningDelegate = self
            
            self.present(wakeUp, animated: true, completion: nil)
        })
    }
    
    //Controls what happens when alarm occurs elsewhere
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        
        completionHandler()
        let wakeUp = storyboard!.instantiateViewController(withIdentifier: "WakeUpViewController") as! WakeUpViewController
        wakeUp.transitioningDelegate = self
        
        present(wakeUp, animated: false, completion: nil)
        
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
