//
//  CalcuatorBrain.swift
//  Calculator
//
//  Created by weiwu du on 2017/12/13.
//  Copyright © 2017年 suning. All rights reserved.
//

import Foundation


struct CalcuatorBrain {
    
    private(set) var result: Double? {
        // 当我们的结果发生改变时候，我们将它设置为下次可能作为的操作数
        // 这样可以继续 接着 计算其他的
        didSet {
            if result != nil {
                operand = result
            }
        }
    }
    
    private var operand: Double?
    
    private var pendingOperation: PendingBinaryOperation?
    
    // 设置操作数
    mutating func setOperand(_ operand: Double) {
        self.operand = operand
        result = operand
    }
    
    // 执行计算
    mutating func performOperation(_ symbol: String) {
        
        // 这里 强制 解包 以此发现bug ，按道理一定能得到
        let operation = operations[symbol]!
        
        switch operation {
        case .constant(let value):
            result = value
            pendingOperation = nil
        case .unary(let function):
            if operand != nil {
                result = function(operand!)
            }
        case .binary(let function):
            // 如果是二元 操作，要先记录下 第一个操作数，和操作符
            if operand != nil {
                pendingOperation = PendingBinaryOperation(firstOperand: operand!, operation: function)
                result = nil
            }
        case .equal:
            if pendingOperation != nil && operand != nil {
                result = pendingOperation?.perform(with: operand!)
            }
        }
    }
    
    // 等待中的操作数和操作符
    private struct PendingBinaryOperation {
        let firstOperand: Double
        let operation: (Double, Double) -> Double
        func perform(with secoundOperand: Double) -> Double {
            return operation(firstOperand,secoundOperand)
        }
    }
    
    
    // 定义操作类型
    private enum Operation {
        // 常量操作
        case constant(Double)
        // 一元操作
        case unary((Double) -> Double)
        // 二元操作
        case binary((Double,Double) -> Double)
        // ..equal
        case equal
    }
    
    // 定于 操作符 对应的操作
    private var operations: [String: Operation] = [
        "AC":   .constant(0),   // 清空，直接返回0
        "±" :   .unary({-$0}),
        "%" :   .unary({$0 / 100}),
        "+" :   .binary( + ),
        "−" :   .binary( - ),
        "×" :   .binary( * ),
        "/" :   .binary( / ),
        "=" :   .equal,
    ]
    
}
