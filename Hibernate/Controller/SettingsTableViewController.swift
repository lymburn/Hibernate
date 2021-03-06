//
//  SettingsTableViewController.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-05-07.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import UIKit
import UserNotifications
import PMAlertController
import StoreKit

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
    }
    
    func setGradientBackground() {
        let gradient = CAGradientLayer()
        let gradientLocations = [0.0,1.0]
        
        gradient.frame = view.bounds;
        let primaryColor = UIColor.black.cgColor
        let secondaryColor = UIColor.init(displayP3Red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: 1.0).cgColor
        gradient.colors = [primaryColor, secondaryColor]
        gradient.locations = gradientLocations as [NSNumber]?
        
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.layer.insertSublayer(gradient, at: 0)
        tableView.backgroundView = backgroundView
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.backgroundColor = UIColor.clear
        
        //Navigation bar colors
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.tintColor = UIColor.clear
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
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
        if cell?.reuseIdentifier == "Alarm Sound" {
            let alarmSounds = storyboard?.instantiateViewController(withIdentifier: "AlarmSoundsTableViewController") as! AlarmSoundsTableViewController
            let navController = UINavigationController(rootViewController:  alarmSounds)
            present(navController, animated: true, completion: nil)
        } else if cell?.reuseIdentifier == "Sleep Sound" {
            let sleepSounds = storyboard?.instantiateViewController(withIdentifier: "SleepingSoundsTableViewController") as! SleepingSoundsTableViewController
            let navController = UINavigationController(rootViewController: sleepSounds)
            present(navController, animated: true, completion: nil)
        } else if cell?.reuseIdentifier == "Sound Duration" {
            let soundDuration = storyboard?.instantiateViewController(withIdentifier: "SoundDurationTableViewController") as! SoundDurationTableViewController
            let navController = UINavigationController(rootViewController: soundDuration)
            present(navController, animated: true, completion: nil)
        } else if cell?.reuseIdentifier == "Premium" {
            let premiumOn = UserDefaults.standard.bool(forKey: "premiumOn")
            //If user does not have premium
            if !premiumOn {
                requestProduct()
            } else {
                displayAlreadyHasPremiumAlert()
            }
        } else if cell?.reuseIdentifier == "Feedback" {
            //Link to facebook page
            guard let url = URL(string: "https://www.facebook.com/Hibernate-169982340334075/") else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else if cell?.reuseIdentifier == "Rate Us" {
            guard let url = URL(string : "itms-apps://itunes.apple.com/app/hibernate/id1383595639?ls=1&mt=8") else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //Premium product to be sold
    var product : SKProduct!
    //Manage in app purchases
    let store = IAPHelper(productIds: Set(["com.eugenelu.hibernate.Hibernate.Premium"]))
    
    //Request for the product info
    private func requestProduct() {
        store.requestProducts {
            (success, products)  in
            guard let products = products else {
                print ("products nil")
                return
            }
            self.product = products[0]
            self.displayPremiumAlert()
        }
    }
    
    private func displayPremiumAlert() {
        let premiumAlertVC = PMAlertController(title: "Premium $\(product.price)", description: "Upgrade to premium for the full Hibernate experience! Get lifetime access to new refreshing wake up music as well as soothing sleep sounds!", image: UIImage(named: "hibernation.png"), style: .walkthrough)
        premiumAlertVC.addAction(PMAlertAction(title: "Purchase", style: .default, action: {()->Void in self.purchaseButtonTapped()}))
        premiumAlertVC.addAction(PMAlertAction(title: "Restore", style: .default, action: {() in self.restoreButtonTapped()}))
        premiumAlertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: nil))
        present(premiumAlertVC, animated: true, completion: nil)
    }
    
    private func displayAlreadyHasPremiumAlert() {
        let hasPremiumAlertVC = PMAlertController(title: "Premium Enabled", description: "Premium is already enabled on this device. Enjoy the new features!", image: nil, style: .alert)
        hasPremiumAlertVC.addAction(PMAlertAction(title: "Great!", style: .default, action: nil))
        present(hasPremiumAlertVC, animated: true, completion: nil)
    }
    
    private func purchaseButtonTapped() {
        store.buyProduct(product)
    }
    
    private func restoreButtonTapped() {
        store.restorePurchases()
    }
}
