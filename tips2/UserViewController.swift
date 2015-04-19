//
//  UserViewController.swift
//  tips2
//
//  Created by Marcus J. Ellison on 3/25/15.
//  Copyright (c) 2015 Marcus J. Ellison. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var themeSwitch: UISwitch!
    @IBOutlet weak var defaultTipControl: UISegmentedControl!
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let intValue = defaults.integerForKey("tipDefaultAmount") as Int? {
            defaultTipControl.selectedSegmentIndex = intValue
        }
        
        if let themeValue = defaults.boolForKey("theme") as Bool? {
            themeSwitch.on = themeValue
        } else {
            themeSwitch.on = false
        }
        
    }
    
    @IBAction func goBack(sender: AnyObject) {
        
        let defaultTip = defaultTipControl.selectedSegmentIndex
        
        defaults.setInteger(defaultTip, forKey: "tipDefaultAmount")
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func themeToggle(sender: AnyObject) {
        
        if themeSwitch.on {
            var theme = true
            defaults.setBool(theme, forKey: "theme")
        } else {
            var theme = false
            defaults.setBool(theme, forKey: "theme")
            
        }
    }
    
}
