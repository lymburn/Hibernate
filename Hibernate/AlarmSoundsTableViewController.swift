//
//  AlarmSoundsTableViewController.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-05-08.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import UIKit

class AlarmSoundsTableViewController: UITableViewController {
    var audioManager = AudioManager()
    var alarmSongName : String!
    var defaultCell : UITableViewCell! //Cell selected by default
    var firstTimeSelecting : Bool = true
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        audioManager.fadeOutMusic()
        //Store option for alarm sound to be played
        UserDefaults.standard.set(alarmSongName, forKey: "alarmSound")
        let settings = storyboard!.instantiateViewController(withIdentifier: "SettingsTableViewController") as! SettingsTableViewController
        let navController = UINavigationController(rootViewController: settings)
        present(navController, animated: true, completion: nil)
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let rowsPerSection = [3, 6]
        return rowsPerSection[section]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if (defaultCell == cell && firstTimeSelecting) {
                //If selected cell with a checkmark already, keep checkmark there
                firstTimeSelecting = false
                cell.accessoryType = .checkmark
                cell.tintColor = UIColor.white
            } else if (defaultCell != cell && firstTimeSelecting){
                //If selected cell thats not the default one, delete default checkmark and check new one
                firstTimeSelecting = false
                defaultCell.accessoryType = .none
                cell.accessoryType = .checkmark
            } else {
                //After default checkmark handled, always turn cell checkmark on
                cell.accessoryType = .checkmark
            }
            
            switch cell.reuseIdentifier! {
                case "Summer": playSampleMusic(songName: "Summer")
                case "A New Beginning": playSampleMusic(songName: "A New Beginning")
                case "Memories": playSampleMusic(songName: "Memories")
                case "Clear Day": playSampleMusic(songName: "Clear Day")
                case "A Day To Remember": playSampleMusic(songName: "A Day To Remember")
                case "Happy Rock": playSampleMusic(songName: "Happy Rock")
                case "Cute": playSampleMusic(songName: "Cute")
                case "Little Idea": playSampleMusic(songName: "Little Idea")
                case "Buddy": playSampleMusic(songName: "Buddy")
                default: playSampleMusic(songName: "Summer")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    //Stop running music and play sample music
    func playSampleMusic(songName: String) {
        audioManager.stopPlayingMusic()
        audioManager.playSampleMusic(songName: songName)
        alarmSongName = songName
        UserDefaults.standard.set(alarmSongName, forKey: "alarmSound")
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        //Add a checkmark to the current cell with the selected song
        if let currentSound = UserDefaults.standard.string(forKey: "alarmSound"),
            let cellIdentifier = cell.reuseIdentifier, cellIdentifier == currentSound {
            cell.accessoryType = .checkmark
            defaultCell = cell
            alarmSongName = currentSound
        }
    }
}
