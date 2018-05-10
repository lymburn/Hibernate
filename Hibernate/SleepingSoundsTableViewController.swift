//
//  SleepingSoundsTableViewController.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-05-09.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import UIKit

class SleepingSoundsTableViewController: UITableViewController {

    var timer = Timer()
    
    @IBAction func didPressBack(_ sender: UIBarButtonItem) {
        didLeaveSoundSettings()
        let settings = storyboard!.instantiateViewController(withIdentifier: "SettingsTableViewController") as! SettingsTableViewController
        let navController = UINavigationController(rootViewController: settings)
        present(navController, animated: true, completion: nil)
    }

    @IBOutlet weak var lightRainImage: SleepSoundImage!
    @IBOutlet weak var mountainStreamImage: SleepSoundImage!
    @IBOutlet weak var stormImage: SleepSoundImage!
    @IBOutlet weak var campfireImage: SleepSoundImage!
    @IBOutlet weak var birdImage: SleepSoundImage!
    @IBOutlet weak var wavesImage: SleepSoundImage!
    
    //Set the sound names for all the custom image views
    private func setImageViews() {
        setImageViewsSleepSoundName()
        enableUserInteraction()
        setImages()
    }
    
    //Set identifiers for which image was pressed
    private func setImageViewsSleepSoundName() {
        lightRainImage.sleepSoundName = "Light Rain"
        mountainStreamImage.sleepSoundName = "Stream"
        stormImage.sleepSoundName = "Storm"
        campfireImage.sleepSoundName = "Campfire"
        wavesImage.sleepSoundName = "Waves"
        birdImage.sleepSoundName = "Forest Songbird"
    }
    
    //Enable user interactions for all the imageviews
    private func enableUserInteraction() {
        lightRainImage.isUserInteractionEnabled = true
        mountainStreamImage.isUserInteractionEnabled = true
        stormImage.isUserInteractionEnabled = true
        campfireImage.isUserInteractionEnabled = true
        wavesImage.isUserInteractionEnabled = true
        birdImage.isUserInteractionEnabled = true
    }
    
    private func setImages() {
        //Set all the colored and grayscale images
        lightRainImage.originalImage = UIImage(named: "light rain.jpg")
        lightRainImage.grayImage = UIImage(named: "Light Rain Gray.jpg")
        mountainStreamImage.originalImage = UIImage(named: "stream.jpg")
        mountainStreamImage.grayImage = UIImage(named: "Stream Gray.jpg")
        stormImage.originalImage = UIImage(named: "storm.jpg")
        stormImage.grayImage = UIImage(named: "Storm Gray.jpg")
        campfireImage.originalImage = UIImage(named: "campfire.jpg")
        campfireImage.grayImage = UIImage(named: "Campfire Gray.jpg")
        wavesImage.originalImage = UIImage(named: "waves.jpg")
        wavesImage.grayImage = UIImage(named: "Waves Gray.jpg")
        birdImage.originalImage = UIImage(named: "bird.jpg")
        birdImage.grayImage = UIImage(named: "Bird Gray.jpg")
    }
    
    private func didLeaveSoundSettings() {
        //Set the bools for the SleepSoundImage class to true so music will fade out
        lightRainImage.didLeaveSleepSoundsSetting = true
        mountainStreamImage.didLeaveSleepSoundsSetting = true
        stormImage.didLeaveSleepSoundsSetting = true
        campfireImage.didLeaveSleepSoundsSetting = true
        wavesImage.didLeaveSleepSoundsSetting = true
        birdImage.didLeaveSleepSoundsSetting = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        setImageViews()
    }
    
    private func setGradientBackground() {
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
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
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
        let rowsPerSection = [1,2]
        return rowsPerSection[section]
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}
