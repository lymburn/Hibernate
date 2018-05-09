//
//  ViewController.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-04-29.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import UIKit
import UserNotifications

class StartViewController: UIViewController {
    
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
    
    //Local variables
    let fadeTransition = FadeAnimator()
    let dateFormatter = DateFormatter()
    var imageName : String!
    var greetingText : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setSleepButtonAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBackgroundImageAndGreeting()
        //Turn off notificiations when start screen appears
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setSleepButtonAttributes() {
        //Set button to be rounded and add different images for selected/unselected
        sleepButton.backgroundColor = .clear
        sleepButton.setTitle("Sleep", for: .normal)
        //sleepButton.layer.cornerRadius = 15
        //sleepButton.layer.borderWidth = 2
        sleepButton.layer.borderColor = UIColor.clear.cgColor
        sleepButton.addTarget(self, action: #selector(startHighlight), for: .touchDown)
        sleepButton.addTarget(self, action: #selector(stopHighlight), for: .touchUpInside)
        sleepButton.addTarget(self, action: #selector(stopHighlight), for: .touchUpOutside)
    }
    
    @objc func startHighlight(sender: UIButton) {
        sleepButton.layer.borderColor = UIColor.lightGray.cgColor
        sleepButton.setTitleColor(UIColor.gray, for: .normal)
    }
    
    @objc func stopHighlight(sender: UIButton) {
        sleepButton.layer.borderColor = UIColor.white.cgColor
        sleepButton.setTitleColor(UIColor.white, for: .normal)
        
        let selectSleep = storyboard!.instantiateViewController(withIdentifier: "SelectSleepViewController") as! SelectSleepViewController
        selectSleep.transitioningDelegate = self
        present(selectSleep, animated: true, completion: nil)
    }
    
    //Set background image and greeting based off current time
    private func setBackgroundImageAndGreeting() {
        let currentDate = Date()
        let currentDateComponents = Calendar.current.dateComponents([.hour], from: currentDate)
        if (currentDateComponents.hour! < 12) {
            //If before noon
            imageName = "blur.jpg"
            greetingText = "Good Morning"
        } else {
            //If past noon
            imageName = "snowflakes.jpg"
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

