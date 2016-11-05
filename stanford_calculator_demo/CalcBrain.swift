//
//  CalcBrain.swift
//  stanford_calculator_demo
//
//  Created by Shihao Zhang on 11/4/16.
//  Copyright © 2016 David Zhang. All rights reserved.
//

import Foundation

func multiply(op1: Double, op2: Double) -> Double{
    return op1 * op2;
}
func divide(op1: Double, op2: Double) -> Double{
    return op1 / op2;
}
func add(op1: Double, op2: Double) -> Double{
    return op1 + op2;
}
func minus(op1: Double, op2: Double) -> Double{
    return op1 - op2;
}
func negate(op: Double) -> Double{
    return -1 * op;
}


class CalculatorBrain{
    struct PendingBinaryOp {
        var function: (Double, Double)->Double
        var firstOperand: Double
    }
    private var _accumulator: Double = 0.0
    private var _pending: PendingBinaryOp?
    
    func setOperand(operand: Double) {
        if _pending != nil{
            _accumulator = (_pending?.function((_pending?.firstOperand)!, operand))!
            _pending = nil
        }
        else{
            _accumulator = operand
        }
    }
    
    enum Operation {
        case Constant(Double)   // associate value
        case UnaryOp((Double) -> Double)
        case BinaryOp((Double, Double) -> Double)
        case Equals
    }
    var _opMap: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOp(sqrt),
        "cos": Operation.UnaryOp(cos),
        "x": Operation.BinaryOp({ return $0 * $1}),
        "÷": Operation.BinaryOp({ return $0 / $1}),
        "+": Operation.BinaryOp({ return $0 + $1}),
        "-": Operation.BinaryOp({ return $0 - $1}),
        "=": Operation.Equals
    ]
    
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
    }
    

    var result: Double {
        get {
            return _accumulator
        }
    }
}
