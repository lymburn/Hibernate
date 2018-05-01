//
//  SleepViewController.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-05-01.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import UIKit

class SleepViewController: UIViewController {
    let dateFormatter = DateFormatter()
    var timer = Timer()
    
    @IBOutlet weak var wakingTimeLabel: UILabel! {
        didSet {
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
}
