//
//  ViewController.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-04-29.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var sleepButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var greetingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setSleepButtonAttributes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setSleepButtonAttributes() {
        //Set button to be rounded and add different images for selected/unselected
        sleepButton.backgroundColor = .clear
        sleepButton.setTitle("Sleep", for: .normal)
        sleepButton.layer.cornerRadius = 15
        sleepButton.layer.borderWidth = 2
        sleepButton.layer.borderColor = UIColor.white.cgColor
        sleepButton.addTarget(self, action: #selector(startHighlight), for: .touchDown)
        sleepButton.addTarget(self, action: #selector(stopHighlight), for: .touchUpInside)
        sleepButton.addTarget(self, action: #selector(stopHighlight), for: .touchUpOutside)
    }
    
    @objc func startHighlight(sender: UIButton) {
        sleepButton.layer.borderColor = UIColor.gray.cgColor
        sleepButton.setTitleColor(UIColor.gray, for: .normal)
    }
    
    @objc func stopHighlight(sender: UIButton) {
        sleepButton.layer.borderColor = UIColor.white.cgColor
        sleepButton.setTitleColor(UIColor.white, for: .normal)
    }
    
}

