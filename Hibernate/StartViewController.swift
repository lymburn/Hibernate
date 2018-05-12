//
//  ViewController.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-04-29.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import UIKit
import UserNotifications
import PMAlertController

class StartViewController: UIViewController {
    //MARK: Local variables
    let fadeTransition = FadeAnimator()
    let dateFormatter = DateFormatter()
    var imageName : String!
    var greetingText : String!
    var timer = Timer()
    
    @IBOutlet weak var settingsButton: UIButton! {
        didSet {
            settingsButton.alpha = 0
        }
    }
    
    @IBAction func settingsButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {()->Void in
            //Move labels/buttons up and fade out
            self.currentTimeLabel.transform = CGAffineTransform(translationX: 0, y: -50)
            self.greetingLabel.transform = CGAffineTransform(translationX: 0, y: -50)
            self.sleepButton.transform = CGAffineTransform(translationX: 0, y: 50)
            self.settingsButton.transform = CGAffineTransform(translationX: 0, y: -50)
            self.currentTimeLabel.alpha = 0
            self.greetingLabel.alpha = 0
            self.sleepButton.alpha = 0
            self.settingsButton.alpha = 0
        }, completion: nil)
        
        let settings = storyboard!.instantiateViewController(withIdentifier: "SettingsTableViewController") as! SettingsTableViewController
        SettingsTableViewController.previousView = "start"
        let navController = UINavigationController(rootViewController: settings)
        navController.transitioningDelegate = self
        present(navController, animated: true, completion: nil)
    }
    
    //Outlets
    @IBOutlet weak var sleepButton: UIButton! {
        didSet {
            sleepButton.alpha = 0
        }
    }
    
    @IBAction func didPressSleep(_ sender: UIButton) {
        let selectSleep = storyboard!.instantiateViewController(withIdentifier: "SelectSleepViewController") as! SelectSleepViewController
        selectSleep.transitioningDelegate = self
        present(selectSleep, animated: true, completion: nil)
    }
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var greetingLabel: UILabel! {
        didSet {
            greetingLabel.alpha = 0
        }
    }
    
    @IBOutlet weak var currentTimeLabel: UILabel! {
        didSet {
            currentTimeLabel.alpha = 0
            dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm a")
            let currentDate = Date()
            currentTimeLabel.text! = dateFormatter.string(from: currentDate)
        }
    }
    
    private func checkNotificationAuthorization () {
        //Check if notifications are enabled and if not, show an alert
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .denied {
                // Notifications denied or undetermined
                self.displayNotificationAlert()
            }
        }
    }
    
    private func displayNotificationAlert() {
        let turnOnNotificationsAlert = PMAlertController(title: "Enable Notifications", description: "Hibernate requires notifications to be enabled in order to wake you up! Please go to Settings -> Notifications -> Hibernate to enable notifications.", image: nil, style: .alert)
        turnOnNotificationsAlert.addAction(PMAlertAction(title: "Understood!", style: .default, action: nil))
        present(turnOnNotificationsAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateCurrentTime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBackgroundImageAndGreeting()
        UIView.animate(withDuration: 1.0, animations: {()->Void in
            //Fade in and translate up
            self.sleepButton.alpha = 1.0
            self.greetingLabel.alpha = 1.0
            self.currentTimeLabel.alpha = 1.0
            self.settingsButton.alpha = 1.0
            self.sleepButton.transform = CGAffineTransform(translationX: 0, y: -50)
            self.greetingLabel.transform = CGAffineTransform(translationX: 0, y: -50)
            self.currentTimeLabel.transform = CGAffineTransform(translationX: 0, y: -50)
            self.settingsButton.transform = CGAffineTransform(translationX: 0, y: -50)
            
            self.backgroundImage.image! = UIImage(named: self.imageName)!
            self.greetingLabel.text! = self.greetingText
        }, completion: nil)
        checkNotificationAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateCurrentTime() {
        //Run timer to update current time every second
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {(timer)->Void in
            let currentTime = Date()
            self.currentTimeLabel.text! = self.dateFormatter.string(from: currentTime)
        })
    }
    
    //Set background image and greeting based off current time
    private func setBackgroundImageAndGreeting() {
        let currentDate = Date()
        let currentDateComponents = Calendar.current.dateComponents([.hour], from: currentDate)
        if (currentDateComponents.hour! < 12 && currentDateComponents.hour! >= 6) {
            //If before noon
            imageName = "morning.jpg"
            greetingText = "Good Morning"
        } else if (currentDateComponents.hour! >= 12 && currentDateComponents.hour! <= 18){
            //If afternoon
            imageName = "afternoon.jpg"
            greetingText = "Good Afternoon"
        } else {
            //Evening
            imageName = "boat.jpg"
            greetingText = "Good Evening"
        }
    }
}

extension StartViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //Decide whether to return a custom animation
        return fadeTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //Deal with dismissing view controllers
        return nil
    }
}

