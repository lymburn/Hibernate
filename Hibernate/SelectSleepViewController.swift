//
//  SelectSleepViewController.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-04-30.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import UIKit

class SelectSleepViewController: UIViewController, UIPickerViewDelegate {
    //Format date
    let dateFormatter = DateFormatter()
    var timer = Timer()
    
    @IBOutlet weak var wakeUpTimeLabel: UILabel!
    @IBOutlet weak var wakeUpTimePicker: UIDatePicker! {
        didSet {
            //Initially hidden
            wakeUpTimePicker.alpha = 0
        }
    }
    
    @IBOutlet weak var startSleepButton: UIButton!
    
    @IBOutlet weak var setAlarmButton: UIButton!
    @IBAction func setAlarmButton(_ sender: UIButton) {
        //Hide alarm and time label after pressing
        sender.alpha = 0
        wakeUpTimeLabel.alpha = 0
        //Show date picker and set to time of wake up label
        wakeUpTimePicker.isHidden = false
        wakeUpTimePicker.setValue(UIColor.white, forKey: "textColor")
        wakeUpTimePicker.setValue(false, forKey: "highlightsToday")
        UIView.animate(withDuration: 0.5, animations: {()->Void in self.wakeUpTimePicker.alpha = 1.0}) {(finished)->Void in
            self.startTimer()
        }
    }
    
    private func startTimer() {
        //Start timer to fade out after not selecting date for 3 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: {(timer)->Void in
            //Fade out after 3s
            UIView.animate(withDuration: 0.5, animations: {()->Void in
                //Fade in label and buttons while fading out time picker
                self.wakeUpTimePicker.alpha = 0
                self.setAlarmButton.alpha = 1.0
                self.wakeUpTimeLabel.alpha = 1.0
                let wakeUpDate = self.wakeUpTimePicker.date
                self.wakeUpTimeLabel.text! = self.dateFormatter.string(from: wakeUpDate)
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
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
