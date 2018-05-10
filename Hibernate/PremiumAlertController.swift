//
//  PremiumAlertController.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-05-10.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import UIKit

class PremiumAlertController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    //MARK: IBActions
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtons()
        setContainer()
    }
}

//MARK: -Setup
extension PremiumAlertController {
    //Set UI elements
    func setButtons() {
        upgradeButton.clipsToBounds = true
        upgradeButton.layer.cornerRadius = 10
        cancelButton.clipsToBounds = true
        cancelButton.layer.cornerRadius = 10
    }
    
    func setContainer() {
        container.clipsToBounds = true
        container.layer.cornerRadius = 10
    }
    
    static func instance() -> PremiumAlertController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: self))
        let controller = storyboard.instantiateViewController(withIdentifier: "PremiumAlertController") as! PremiumAlertController
        return controller
    }
}
