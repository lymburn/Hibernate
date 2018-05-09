//
//  SettingsTableViewController.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-05-07.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsTableViewController: UITableViewController {
    static var previousView : String! //Track what the previous view was so it can return to it

    @IBOutlet weak var alarmSwitch: UISwitch! {
        didSet {
            alarmSwitch.setOn(UserDefaults.standard.bool(forKey: "alarmOn"), animated: false)
        }
    }
    @IBAction func alarmSwitched(_ sender: UISwitch) {
        //If switch on, set true for alarm option.
        UserDefaults.standard.set(sender.isOn, forKey: "alarmOn")
        //If off, remove all pending notifications
        if (!sender.isOn) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        //Return to previous view controller
        if SettingsTableViewController.previousView == "start" {
            let start = self.storyboard!.instantiateViewController(withIdentifier: "StartViewController") as! StartViewController
            present(start, animated: true, completion: nil)
        } else if SettingsTableViewController.previousView == "selectSleep" {
            let selectSleep = self.storyboard!.instantiateViewController(withIdentifier: "SelectSleepViewController") as! SelectSleepViewController
            present(selectSleep, animated: true, completion: nil)
        } else if SettingsTableViewController.previousView == "sleep" {
            let sleep = self.storyboard!.instantiateViewController(withIdentifier: "SleepViewController") as! SleepViewController
            present(sleep, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var sleepAidSwitch: UISwitch! {
        didSet {
            sleepAidSwitch.setOn(UserDefaults.standard.bool(forKey: "sleepAidOn"), animated: false)
        }
    }
    @IBAction func sleepAidSwitched(_ sender: UISwitch) {
        //If switch on, set true for sleeping music option.
        UserDefaults.standard.set(sender.isOn, forKey: "sleepAidOn")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        setDefaultSettings()
    }
    
    func setDefaultSettings() {
        UserDefaults.standard.set(sleepAidSwitch.isOn, forKey: "sleepAidOn")
        UserDefaults.standard.set(alarmSwitch.isOn, forKey: "alarmOn")
    }
    
    func setGradientBackground() {
        let gradient = CAGradientLayer()
        let gradientLocations = [0.0,1.0]
        
        gradient.frame = view.bounds;
        let primaryColor = UIColor.init(displayP3Red: 245/255.0, green: 247/255.0, blue: 250/255.0, alpha: 1.0).cgColor
        let secondaryColor = UIColor.init(displayP3Red: 195/255.0, green: 207/255.0, blue: 226/255.0, alpha: 1.0).cgColor
        gradient.colors = [primaryColor, secondaryColor]
        gradient.locations = gradientLocations as [NSNumber]?
        
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.layer.insertSublayer(gradient, at: 0)
        tableView.backgroundView = backgroundView
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.backgroundColor = UIColor.clear
        
        //Navigation bar colors
        navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 245/255.0, green: 247/255.0, blue: 250/255.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.init(displayP3Red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let rowsPerSection = [2, 3, 3]
        return rowsPerSection[section]
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        //Perform tasks based on which cell is selected
        if (cell?.reuseIdentifier == "Alarm Sound") {
            print("alarm")
            let alarmSounds = storyboard?.instantiateViewController(withIdentifier: "AlarmSoundsTableViewController") as! AlarmSoundsTableViewController
            let navController = UINavigationController(rootViewController:  alarmSounds)
            present(navController, animated: true, completion: nil)
        } else if (cell?.reuseIdentifier == "Sleep Sound") {
            print("sleep sound")
        } else if (cell?.reuseIdentifier == "Sound Duration") {
            let soundDuration = storyboard?.instantiateViewController(withIdentifier: "SoundDurationTableViewController") as! SoundDurationTableViewController
            let navController = UINavigationController(rootViewController: soundDuration)
            present(navController, animated: true, completion: nil)
        } else if (cell?.reuseIdentifier == "Feedback") {
            guard let url = URL(string: "http://www.google.com") else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
}
