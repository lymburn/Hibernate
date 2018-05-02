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
        scheduleNotification()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateCurrentTime()
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
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Good morning"
        content.body = "Enjoy the day"
        content.sound = UNNotificationSound.default()
        
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: wakeUpDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let identifier = "AlarmNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request, withCompletionHandler: {(error) in
            if let error = error {
                print (error.localizedDescription)
            }
        })
    }
}

extension SleepViewController: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        completionHandler()
    }
}
