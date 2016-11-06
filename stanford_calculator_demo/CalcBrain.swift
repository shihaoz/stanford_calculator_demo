//
//  CalcBrain.swift
//  stanford_calculator_demo
//
//  Created by Shihao Zhang on 11/4/16.
//  Copyright © 2016 David Zhang. All rights reserved.
//

import Foundation


class CalculatorBrain{
    
    /*    private variables      */
    struct PendingBinaryOp {
        var function: (Double, Double)->Double
        var firstOperand: Double
    }
    private var _accumulator: Double = 0.0  // accumulator value
    private var _pending: PendingBinaryOp?  // BinaryOp
    private var _actions = ""   // log of actions
    
    enum Operation {    // types of operations
        case Constant(Double)   // associate value
        case UnaryOp((Double) -> Double)
        case BinaryOp((Double, Double) -> Double)
        case Equals
    }
    
    private var _opMap: Dictionary<String, Operation> = [   // map from string -> Operation
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        
        "√": Operation.UnaryOp(sqrt),
        "cos": Operation.UnaryOp(cos),
        "sin": Operation.UnaryOp(sin),
        "tan": Operation.UnaryOp(tan),
        "log": Operation.UnaryOp(log),
        "%": Operation.UnaryOp({ return $0/100 }),
        
        "x": Operation.BinaryOp({ return $0 * $1}),
        "÷": Operation.BinaryOp({ return $0 / $1}),
        "+": Operation.BinaryOp({ return $0 + $1}),
        "-": Operation.BinaryOp({ return $0 - $1}),
        
        "=": Operation.Equals,
        ]
    
    /*          public properties          */
    var isPartialResult: Bool{
        get{
            return _pending != nil
        }
    }
    var result: Double {
        get {
            return _accumulator
        }
    }
    var description: String{
        get{
            return _actions
        }
    }
    
    
    /*      public methods      */
    func _clear(){// "C" --> clear all
        _pending = nil
        _accumulator = 0.0
        _actions = ""
    }
    
    func setOperand(operand: Double) {
        if _pending != nil{
            _accumulator = (_pending?.function((_pending?.firstOperand)!, operand))!
            _pending = nil
        }
        else{
            _accumulator = operand
        }
        _actions += " \(operand)"
    }
    
    func performOperation(symbol: String) {
        if let op = _opMap[symbol]{
            switch op {
            case .Constant(let value):
                _accumulator = value
            case .UnaryOp(let function):
                _accumulator = function(_accumulator)
            case .BinaryOp(let function):
                _pending = PendingBinaryOp(function: function, firstOperand: _accumulator)
            case .Equals:
                if _pending != nil{
                    _accumulator = _pending!.function(_pending!.firstOperand, _accumulator)
                    _pending = nil
                }
                else{
                    
                }
            default:
                break
            }
        }
        _actions += " \(symbol)"
    }
}
