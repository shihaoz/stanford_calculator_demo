//
//  ViewController.swift
//  stanford_calculator_demo
//
//  Created by Shihao Zhang on 11/4/16.
//  Copyright © 2016 David Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var _typingMode = false
    var _dotCount = 0
    
    @IBOutlet weak var display: UILabel!
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "." {
            if _dotCount > 0 { return }
            _dotCount += 1
        }
        if _typingMode {
           display.text = (display.text)! + digit
        }
        else{
            display.text = digit
            _typingMode = true
        }

    }
    
    var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    private var _calculator: CalculatorBrain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        _dotCount = 0   // clear dotCount when operation recevied
        if _typingMode{
            _calculator.setOperand(operand: displayValue)
        }
        _typingMode = false
        if let op = sender.currentTitle{
            _calculator.performOperation(symbol: op)
        }
        
        displayValue = _calculator.result
    }
    
    
    /** utility function */

}

