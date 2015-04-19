//
//  ViewController.swift
//  tips2
//
//  Created by Marcus J. Ellison on 3/23/15.
//  Copyright (c) 2015 Marcus J. Ellison. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    //Global Defaults:
    let tipPercentages = [0.18, 0.20, 0.22]
    let animationDuration = 0.4
    let defaults = NSUserDefaults.standardUserDefaults()
    let initialLabelValue = "$0.00"
    
    let formatter = NSNumberFormatter()
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var splitTwoLabel: UILabel!
    @IBOutlet weak var splitThreeLabel: UILabel!
    @IBOutlet weak var splitFourLabel: UILabel!
    @IBOutlet weak var splitFiveLabel: UILabel!
    @IBOutlet weak var splitSixLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var backgroundUIView: UIView!
    @IBOutlet weak var splitsUIView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        billField.placeholder = "$"
        billField.font = UIFont(name: billField.font.fontName, size: 30)
        
        let labels = [tipLabel, totalLabel, splitTwoLabel, splitThreeLabel, splitFourLabel, splitFiveLabel, splitSixLabel]
        
        setInitialLabelValues(labels)
        
        splitsUIView.alpha = 0
        
        if billField.text != "" || billField.text != "0" {
            println("not empty")
        } else {
            billField.text = ""
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentTime = NSDate()
        let themeBool = defaults.boolForKey("theme")
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        let tipLabels = [tipLabel, splitTwoLabel, splitThreeLabel, splitFourLabel, splitFiveLabel, splitSixLabel]
        
        tipControl.selectedSegmentIndex = defaults.integerForKey("tipDefaultAmount")
        
        let lastAmount = defaults.integerForKey("lastAmount")
        
        showLastAmount(currentTime, lastAmount: Double(lastAmount), tipPercentage: tipPercentage, tipLabels: tipLabels)
        
        adjustTheme(themeBool)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        var amountResetTime = NSDate(timeIntervalSinceNow: 60)
        var defaults = NSUserDefaults.standardUserDefaults()
        var now = NSDate(timeIntervalSinceNow: 60)
        
        // set reset time
        defaults.setObject(now, forKey:"resetTime")

    }
    
    // Our sick animations!
    @IBAction func amountInputTouchDown(sender: AnyObject) {
        // UI View animation
        UIView.animateWithDuration(animationDuration, animations: {
            // This causes first view to fade in and second view to fade out
            self.splitsUIView.alpha = 1
            self.billField.frame = CGRectOffset(self.billField.bounds, 150, 100)
        })
        
    }

    @IBAction func onEditingChanged
        (sender: AnyObject) {
            
            fadeView()
            
            let tipLabels = [tipLabel, splitTwoLabel, splitThreeLabel, splitFourLabel, splitFiveLabel, splitSixLabel]
            let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
            var billAmount = (billField.text as NSString).doubleValue
            
            formatter.numberStyle = .CurrencyStyle
            
            formatter.stringFromNumber(billAmount)
            
            displayTotal(billAmount, tipPercentage: tipPercentage)
            
            adjustTipLabels(billAmount, tipPercentage: tipPercentage, tipLabels: tipLabels)
            
            defaults.setObject(billAmount, forKey:"lastAmount")
    }

    @IBAction func onTap (sender: AnyObject) {
            view.endEditing(true)
            
            if billField.text == "" {
                // UI View animation
                UIView.animateWithDuration(animationDuration, animations: {
                    // This causes first view to fade in and second view to fade out
                    self.splitsUIView.alpha = 0
                    self.billField.frame = CGRectOffset(self.billField.bounds, 150, 167)
                })
            }
    }
    
    func setInitialLabelValues(labels: [UILabel!]) {
        for label in labels {
            label.text = initialLabelValue
        }
    }
    
    func adjustTheme(themeBool:Bool) {
        if themeBool {
            backgroundUIView.backgroundColor = UIColor.greenColor()
            splitsUIView.backgroundColor = UIColor.darkGrayColor()
            titleLabel.textColor = UIColor.orangeColor()
            billField.textColor = UIColor.grayColor()
        } else {
            backgroundUIView.backgroundColor = UIColor.whiteColor()
            titleLabel.textColor = UIColor.blackColor()
            splitsUIView.backgroundColor = UIColor.whiteColor()
            titleLabel.textColor = UIColor.blackColor()
            billField.textColor = UIColor.blackColor()
        }
    }

    func showLastAmount(currentTime: NSDate, lastAmount: Double, tipPercentage: Double, tipLabels: [UILabel!] ) {
        if let resetTime = defaults.objectForKey("resetTime") as? NSDate {
            if resetTime.compare(currentTime) == NSComparisonResult.OrderedAscending {
                billField.text = ""
            } else {
                formatter.numberStyle = .CurrencyStyle
                formatter.stringFromNumber(lastAmount)
                
                billField.text = formatter.stringFromNumber(lastAmount)
                
                adjustTipLabels(Double(lastAmount), tipPercentage: tipPercentage, tipLabels: tipLabels)
                displayTotal(Double(lastAmount), tipPercentage: tipPercentage)
                
                splitsUIView.alpha = 1
                
            }
        }
    }
    
    func fadeView() {
        if billField.text == "" {
            UIView.animateWithDuration(animationDuration, animations: {
                // This causes first view to fade in and second view to fade out
                self.splitsUIView.alpha = 0
            })
            
        } else {
            UIView.animateWithDuration(animationDuration, animations: {
                // This causes first view to fade in and second view to fade out
                self.splitsUIView.alpha = 1
            })
        }
    }
    
    func adjustTipLabels(billAmount: Double, tipPercentage: Double, tipLabels: [UILabel!]) {
        
        for (index, label) in enumerate(tipLabels) {
            var split = (billAmount * tipPercentage) / Double(index+1)
            label.text = formatter.stringFromNumber(split)
        }
    }
    
    func displayTotal(billAmount: Double, tipPercentage: Double) {
        
        var total = billAmount + (billAmount * tipPercentage)
        
        totalLabel.text = formatter.stringFromNumber(total)
    }
    
}

