//
//  ViewController.swift
//  stanford_calculator_demo
//
//  Created by Shihao Zhang on 11/4/16.
//  Copyright © 2016 David Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var _typingMode = false
    
    private var _calculator: CalculatorBrain = CalculatorBrain()
    private var _lastSelectetButton = UIButton()
    @IBOutlet weak var display: UILabel!
    
    
    @IBAction func touchDigit(_ sender: UIButton) {
        buttonTouched(buttonNow: sender)
        
        let digit = sender.currentTitle!
        if digit == "."{
            if ((display.text?.range(of: ".")) != nil){// if . already exists
                return
            }
            if !_typingMode {// dot is entered first
                _typingMode = true
                display.text = "0"
            }
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

    
    @IBAction func performOperation(_ sender: UIButton) {
        buttonTouched(buttonNow: sender)
        if _typingMode{
            _calculator.setOperand(operand: displayValue)
        }
        _typingMode = false
        if let op = sender.currentTitle{
            _calculator.performOperation(symbol: op)
        }
        
        displayValue = _calculator.result
    }
    
    @IBAction func performClear(_ sender: UIButton) {
        buttonTouched(buttonNow: sender)
        let op = sender.currentTitle!

        _typingMode = false // set typingMode = false
        display.text = "0"  // always set display to 0
        switch op {
            
        case "C":   // clear all
            _calculator._clear()
        case "CE":  // clear entry
            break
        default:
            break
        }

    }
    /** utility function */

    private func buttonTouched(buttonNow: UIButton?){
        _lastSelectetButton.isSelected = false
        if buttonNow != nil{
            buttonNow?.isSelected = true
            _lastSelectetButton = buttonNow!
        }
    }
}

