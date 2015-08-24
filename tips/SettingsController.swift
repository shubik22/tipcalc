//
//  SettingsController.swift
//  tips
//
//  Created by Sam Sweeney on 8/23/15.
//  Copyright © 2015 Wealthfront. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var lowTipStepper: UIStepper!
    @IBOutlet weak var middleTipStepper: UIStepper!
    @IBOutlet weak var highTipStepper: UIStepper!
    
    @IBOutlet weak var lowTipLabel: UILabel!
    @IBOutlet weak var middleTipLabel: UILabel!
    @IBOutlet weak var highTipLabel: UILabel!

    let tipIncrement = 0.01
    
    var lowTip:Double = NSUserDefaults.standardUserDefaults().doubleForKey("lowTip")
    var middleTip:Double = NSUserDefaults.standardUserDefaults().doubleForKey("middleTip")
    var highTip:Double = NSUserDefaults.standardUserDefaults().doubleForKey("highTip")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synchronizeSteppers()
        synchronizeTipFields()
    }
    
    func synchronizeSteppers() {
        lowTipStepper.value = lowTip
        middleTipStepper.value = middleTip
        highTipStepper.value = highTip
        
        lowTipStepper.stepValue = tipIncrement
        middleTipStepper.stepValue = tipIncrement
        highTipStepper.stepValue = tipIncrement
        
        lowTipStepper.minimumValue = 0.0
        middleTipStepper.minimumValue = lowTip + tipIncrement
        highTipStepper.minimumValue = middleTip + tipIncrement
        
        lowTipStepper.maximumValue = middleTip - tipIncrement
        middleTipStepper.maximumValue = highTip - tipIncrement
    }

    func synchronizeTipFields() {
        lowTipLabel.text = doubleToPercentage(lowTip)
        middleTipLabel.text = doubleToPercentage(middleTip)
        highTipLabel.text = doubleToPercentage(highTip)
    }
    

    @IBAction func lowTipStepperValueChanged(sender: UIStepper) {
        lowTip = sender.value
        NSUserDefaults.standardUserDefaults().setObject(lowTip, forKey: "lowTip")
        
        synchronizeTipFields()
        synchronizeSteppers()
    }
    
    @IBAction func middleTipStepperValueChanged(sender: UIStepper) {
        middleTip = sender.value
        NSUserDefaults.standardUserDefaults().setObject(middleTip, forKey: "middleTip")
        
        synchronizeTipFields()
        synchronizeSteppers()
    }
    
    @IBAction func highTipStepperValueChanged(sender: UIStepper) {
        highTip = sender.value
        NSUserDefaults.standardUserDefaults().setObject(highTip, forKey: "highTip")
        
        synchronizeTipFields()
        synchronizeSteppers()
    }
    
    func doubleToPercentage(num: Double) -> String {
        let nf = NSNumberFormatter()
        nf.numberStyle = NSNumberFormatterStyle.PercentStyle
        return nf.stringFromNumber(num)!
    }
}
