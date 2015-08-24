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

    @IBAction func onEditingChanged(sender: AnyObject) {
        maybeTruncateBillField()
        
        let tipPercentages = [0.18, 0.2, 0.22]
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        let billAmountText = billField.text!.stringByReplacingOccurrencesOfString("$", withString: "")
        let billAmount = (billAmountText as NSString).doubleValue
        let roundedBillAmount = Double(round(billAmount * 100) / 100)
        let tip = Double(round(roundedBillAmount * tipPercentage * 100) / 100);
        let total = billAmount + tip;
        
        billField.text = "$\(billAmountText)"
        tipLabel.text = String(format: "$%.2f", arguments: [tip])
        totalLabel.text = String(format: "$%.2f", arguments: [total])
    }

    func maybeTruncateBillField() {
        let billAmountArray = billField.text!.characters.split { $0 == "." }.map { String($0) }
        if billAmountArray.count < 2 {
            return
        } else {
            let dollars = billAmountArray[0]
            var cents = billAmountArray[1]
            if cents.characters.count > 2 {
                let centsIndex = advance(cents.startIndex, 2)
                cents = cents.substringToIndex(centsIndex)
            }
            let totalValue = ".".join([dollars, cents])
            billField.text = totalValue
        }
        
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}

