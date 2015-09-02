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
    let maxSecondsToSaveBillAmount = 10.0 * 60
    var lowTip:Double = NSUserDefaults.standardUserDefaults().doubleForKey("lowTip")
    var middleTip:Double = NSUserDefaults.standardUserDefaults().doubleForKey("middleTip")
    var highTip:Double = NSUserDefaults.standardUserDefaults().doubleForKey("highTip")
    var tips:Array<Double> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billField.becomeFirstResponder()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setTipAmounts()
        updateAmounts()
        maybeRetrieveSavedBillAmount()
        setViewPositions()
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
        saveBillAmount()
    }

    func setViewPositions() {
        let billAmountText = billField.text!
        if billAmountText.characters.count > 1 {
            UIView.animateWithDuration(0.3,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0.5,
                options: UIViewAnimationOptions.CurveEaseIn,
                animations: {
                    let float:CGFloat = 1.0
                    self.tipAndTotalView.alpha = CGFloat(float)
                    self.billField.center.y = self.billFieldTopCenter
                },
                completion: nil)
        } else {
            UIView.animateWithDuration(0.3,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0.5,
                options: UIViewAnimationOptions.CurveEaseIn,
                animations: {
                    let float:CGFloat = 0.0
                    self.tipAndTotalView.alpha = CGFloat(float)
                    self.billField.center.y = self.billFieldBottomCenter
                },
                completion: nil)
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
        let billAmountText = billField.text!.stringByReplacingOccurrencesOfString("$", withString: "")
        updateAmountsWithBillAmount(billAmountText)
    }

    func updateAmountsWithBillAmount(billAmountText: String) {
        let billAmount = (billAmountText as NSString).doubleValue
        let tipPercentage = tips[tipControl.selectedSegmentIndex]
        let roundedBillAmount = Double(round(billAmount * 100) / 100)
        let tip = Double(round(roundedBillAmount * tipPercentage * 100) / 100);
        let total = billAmount + tip
        
        billField.text = "$\(billAmountText)"
        tipLabel.text = String(format: "$%.2f", arguments: [tip])
        totalLabel.text = String(format: "$%.2f", arguments: [total])
    }

    func doubleToPercentage(num: Double) -> String {
        let nf = NSNumberFormatter()
        nf.numberStyle = NSNumberFormatterStyle.PercentStyle
        return nf.stringFromNumber(num)!
    }

    func saveBillAmount() {
        let billAmountText = billField.text!.stringByReplacingOccurrencesOfString("$", withString: "")
        let defaults = NSUserDefaults.standardUserDefaults();
        defaults.setObject(billAmountText as NSString, forKey: "billAmountText")
        defaults.setObject(NSDate.init(), forKey: "billAmountLastUpdated")
    }

    func maybeRetrieveSavedBillAmount() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let billAmountText = defaults.objectForKey("billAmountText") {
            let lastUpdated = defaults.objectForKey("billAmountLastUpdated") as! NSDate
            if lastUpdated.timeIntervalSinceNow > -1 * self.maxSecondsToSaveBillAmount {
                updateAmountsWithBillAmount(billAmountText as! String)
            }
        }
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}

