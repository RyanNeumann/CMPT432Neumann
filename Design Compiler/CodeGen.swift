//
//  CodeGen.swift
//  Design Compiler
//
//  Created by Ryan Neumann on 5/6/17.
//  Copyright © 2017 RyanNeumann. All rights reserved.
//

import Foundation

var x: NSArray = []
var y = [Any]()
var stack = ["00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]

var tempTable: NSMutableDictionary = [:]
var tempTableCounter = 0
var currentTermScope = ""
var printBool = false


var pointer = 0

extension ViewController {
    
    func printAcc(){
    
        
        
        var i = 0
        
        var finalTable = ""
        
        var lastPosition = 255
        for value in x {
            
            stack[lastPosition] = value as! String
            lastPosition -= 1
            
        }
        
        while stack.isEmpty == false {
        
            finalTable.append((stack.first! as String) + " ")
            stack.removeFirst()
        
        }
        
        
        
        while (i != tempTableCounter) {
        
            pointer += 1
            //Change pointer to hexidecimal
            let st: String = NSString(format:"%02X", pointer) as String
            finalTable = finalTable.replacingOccurrences(of: ("T" + String(describing: i)), with: st)

            i += 1
        
        }
        
        
        
       print(finalTable)
    }

    
}

extension String {
    var asciiArray: [UInt32] {
        return unicodeScalars.filter{$0.isASCII}.map{$0.value}
    }
}
