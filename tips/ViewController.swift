//
//  ViewController.swift
//  tips
//
//  Created by Sam Sweeney on 8/23/15.
//  Copyright © 2015 Wealthfront. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var tipAndTotalView: UIView!
    
    let billFieldTopCenter = CGFloat.init(105.0)
    let billFieldBottomCenter = CGFloat.init(250.0)
    var lowTip:Double = 0.15
    var middleTip:Double = 0.20
    var highTip:Double = 0.25
    var tips:Array<Double> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTipAmounts()
        updateAmounts()
    }
    
    func setTipAmounts() {
        lowTip = NSUserDefaults.standardUserDefaults().doubleForKey("lowTip")
        middleTip = NSUserDefaults.standardUserDefaults().doubleForKey("middleTip")
        highTip = NSUserDefaults.standardUserDefaults().doubleForKey("highTip")
        tips = [lowTip, middleTip, highTip]
        
        tipControl.setTitle("\(doubleToPercentage(lowTip))", forSegmentAtIndex: 0);
        tipControl.setTitle("\(doubleToPercentage(middleTip))", forSegmentAtIndex: 1);
        tipControl.setTitle("\(doubleToPercentage(highTip))", forSegmentAtIndex: 2);
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        setViewPositions()
        maybeTruncateBillField()
        updateAmounts()
    }
    
    func setViewPositions() {
        let billAmountText = billField.text!
        if billAmountText.characters.count > 1 {
            UIView.animateWithDuration(0.2, animations: {
                self.billField.center.y = self.billFieldTopCenter
            })
            UIView.animateWithDuration(0.5, animations: {
                self.tipAndTotalView.hidden = false
            })
        } else {
            UIView.animateWithDuration(0.2, animations: {
                self.billField.center.y = self.billFieldBottomCenter
            })
            UIView.animateWithDuration(0.5, animations: {
                self.tipAndTotalView.hidden = true
            })
        }
    }
    
    func maybeTruncateBillField() {
        let billAmountArray = billField.text!.characters.split { $0 == "." }.map { String($0) }
        if billAmountArray.count < 2 {
            return
        } else {
            let dollars = billAmountArray[0].stringByReplacingOccurrencesOfString("$", withString: "")
            var cents = billAmountArray[1]
            if cents.characters.count > 2 {
                let centsIndex = advance(cents.startIndex, 2)
                cents = cents.substringToIndex(centsIndex)
            }
            let totalValue = ".".join([dollars, cents])
            billField.text = totalValue
        }
    }
    
    func updateAmounts() {
        let tipPercentage = tips[tipControl.selectedSegmentIndex]
        
        let billAmountText = billField.text!.stringByReplacingOccurrencesOfString("$", withString: "")
        let billAmount = (billAmountText as NSString).doubleValue
        let roundedBillAmount = Double(round(billAmount * 100) / 100)
        let tip = Double(round(roundedBillAmount * tipPercentage * 100) / 100);
        let total = billAmount + tip;
        
        billField.text = "$\(billAmountText)"
        tipLabel.text = String(format: "$%.2f", arguments: [tip])
        totalLabel.text = String(format: "$%.2f", arguments: [total])
    }
    
    func doubleToPercentage(num: Double) -> String {
        let nf = NSNumberFormatter()
        nf.numberStyle = NSNumberFormatterStyle.PercentStyle
        return nf.stringFromNumber(num)!
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}

