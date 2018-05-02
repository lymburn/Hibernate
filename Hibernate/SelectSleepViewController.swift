//
//  SelectSleepViewController.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-04-30.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import UIKit

class SelectSleepViewController: UIViewController, UIPickerViewDelegate {
    //Instance properties
    let dateFormatter = DateFormatter()
    var timer = Timer()
    let fadeTransition = FadeAnimator()
    var wakeUpDate : Date! = Date()
    
    @IBOutlet weak var wakeUpTimeLabel: UILabel!
    @IBOutlet weak var wakeUpTimePicker: UIDatePicker! {
        didSet {
            //Initially hidden
            wakeUpTimePicker.alpha = 0
        }
    }
    
    @IBOutlet weak var startSleepButton: UIButton!
    
    @IBAction func startSleepButton(_ sender: UIButton) {
        //Animate and transition to sleeping view
        UIView.animate(withDuration: 0.5, animations: {()->Void in
            //Move labels/buttons up and fade out
            self.wakeUpTimeLabel.transform = CGAffineTransform(translationX: 0, y: -50)
            self.setAlarmButton.transform = CGAffineTransform(translationX: 0, y: -50)
            self.startSleepButton.transform = CGAffineTransform(translationX: 0, y: 50)
            self.startSleepButton.alpha = 0
            self.setAlarmButton.alpha = 0
            self.wakeUpTimeLabel.alpha = 0
        }, completion: nil)
        
        let sleep = storyboard!.instantiateViewController(withIdentifier: "SleepViewController") as! SleepViewController
        sleep.transitioningDelegate = self
        sleep.wakeUpDate = self.wakeUpDate
        
        present(sleep, animated: true, completion: nil)
    }
    
    @IBOutlet weak var setAlarmButton: UIButton!
    @IBAction func setAlarmButton(_ sender: UIButton) {
        //Hide alarm and time label after pressing
        sender.alpha = 0
        wakeUpTimeLabel.alpha = 0
        //Set time picker color to be white
        wakeUpTimePicker.setValue(UIColor.white, forKey: "textColor")
        wakeUpTimePicker.setValue(false, forKey: "highlightsToday")
        //Fade in time picker when set alarm pressed
        UIView.animate(withDuration: 0.5, animations: {()->Void in self.wakeUpTimePicker.alpha = 1.0}) {(finished)->Void in
            self.startTimer()
        }
    }
    
    private func startTimer() {
        //Start timer to fade out after not selecting date for 3 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: {(timer)->Void in
            //Fade out after 2s
            UIView.animate(withDuration: 0.5, animations: {()->Void in
                //Fade in label and buttons while fading out time picker
                self.wakeUpTimePicker.alpha = 0
                self.setAlarmButton.alpha = 1.0
                self.wakeUpTimeLabel.alpha = 1.0
                self.wakeUpDate = self.wakeUpTimePicker.date
                self.wakeUpTimeLabel.text! = self.dateFormatter.string (from: self.wakeUpDate)
            }, completion: nil)
        })
    }
    
    @objc private func resetTimer() {
        // Invalidate the timer when the picker value changes
        timer.invalidate()
        // (Re)start the timer
        startTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialWakeUpTime()
        wakeUpTimePicker.addTarget(self, action: #selector(resetTimer), for: .valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setInitialWakeUpTime() {
        //Set date formatter to AM/PM mode
        dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm a")
        //Set label for wake up time to time of the date picker
        let wakeUpDate = wakeUpTimePicker.date
        wakeUpTimeLabel.text! = dateFormatter.string(from: wakeUpDate)
    }
}

extension SelectSleepViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //Decide whether to return a custom animation
        return fadeTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //Deal with dismissing view controllers
        return nil
    }
}

