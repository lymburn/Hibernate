//
//  SoundDurationTableViewController.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-05-08.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import UIKit

class SoundDurationTableViewController: UITableViewController {

    @IBAction func goBack(_ sender: UIBarButtonItem) {
        //Save sleep aid duration onto user defaults
        UserDefaults.standard.set(sleepAidDuration, forKey: "sleepAidDuration")
        let settings = storyboard!.instantiateViewController(withIdentifier: "SettingsTableViewController") as! SettingsTableViewController
        let navController = UINavigationController(rootViewController: settings)
        present(navController, animated: true, completion: nil)
    }
    
    var defaultCell : UITableViewCell! //Cell selected by default
    var firstTimeSelecting : Bool = true
    var sleepAidDuration : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        //Add a checkmark to the current cell with the selected song
        let currentDuration = UserDefaults.standard.integer(forKey: "sleepAidDuration")
        if let cellIdentifier = cell.reuseIdentifier,
            cellIdentifier == "\(currentDuration) minutes" {
                cell.accessoryType = .checkmark
                defaultCell = cell
                sleepAidDuration = UserDefaults.standard.integer(forKey: "sleepAidDuration")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if (defaultCell == cell && firstTimeSelecting) {
                //If selected cell with a checkmark already, keep checkmark there
                firstTimeSelecting = false
                cell.accessoryType = .checkmark
            } else if (defaultCell != cell && firstTimeSelecting){
                //If selected cell thats not the default one, delete default checkmark and check new one
                firstTimeSelecting = false
                defaultCell.accessoryType = .none
                cell.accessoryType = .checkmark
            } else {
                //After default checkmark handled, always turn cell checkmark on
                cell.accessoryType = .checkmark
            }
            
            //Set sleep aid duration depending on which cell is selected
            switch cell.reuseIdentifier! {
                case "15 minutes": sleepAidDuration = 15
                case "30 minutes": sleepAidDuration = 30
                case "45 minutes": sleepAidDuration = 45
                case "60 minutes": sleepAidDuration = 60
                case "75 minutes": sleepAidDuration = 75
                case "90 minutes:": sleepAidDuration = 90
                default: sleepAidDuration = 15
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    

}
