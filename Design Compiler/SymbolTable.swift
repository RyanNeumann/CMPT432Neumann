//
// SymbolTable.swift
//  Design Compiler
//
//  Created by Ryan Neumann on 4/9/17.
//  Copyright © 2017 RyanNeumann. All rights reserved.
//

import Foundation

var symbolName: NSArray = []
var symbolType: NSArray = []
var lineNums: NSArray = []
var symbolScope: NSArray = []
var symbolTable: NSArray = []
var scopeTracker = 0
var scopeBool = true
var errorCounter = 0
var test: NSMutableArray = []
var errorArray: NSArray = []

extension ViewController {

    func scopeChecker (_ a: String) {
        
        var testArray: NSArray = []
        var x = 0
        for g in symbolName {
        
            testArray = testArray.adding(String(describing: g) + "," + String(describing: symbolScope[x])) as NSArray
            x += 1
        
        }
        
        var numCounter = scopeTracker
        
            while numCounter > 0 {
                
                     if (testArray.contains(a + "," + String(describing: numCounter))) {
                        
                        scopeBool = false
                        break
                        
                     } else {
                    
                        scopeBool = true
                        numCounter -= 1
                        
                    }
                
            }
    
        if scopeBool == true {
            
            test.insert("true", at: programNum)
            errorArray = errorArray.adding("Error: the id \(a) on line \(currentLine) was used before being declared.") as NSArray
            errorCounter += 1
            
        } else {
            
            test.insert("false", at: programNum)
            
        }
      
    }
    
    func produceSymbolTable () {
        
        finalList.append("Program \(programNum) Semantic Analysis")
        symbolList.string?.append("Program \(programNum) Symbol Table\n")
        
        if test.count > 0 {
            
            if String(describing: test[programNum]) == "false" {
                
                var current = 0
                
                if symbolType.count > 0 {
                    
                    symbolTable = symbolTable.adding("-------------------------------------------") as NSArray
                    symbolTable = symbolTable.adding(" Name | Type | Scope | Line") as NSArray
                    symbolTable = symbolTable.adding("-------------------------------------------") as NSArray
                    
                }
                
                for i in symbolType {
                    
                    if  String(describing: i) == "string" {
                        
                        symbolTable = symbolTable.adding("    \(symbolName[current])          \(i)      \(symbolScope[current])          \(lineNums[current])") as NSArray
                        
                    } else if  String(describing: i) == "bool" {
                        
                        symbolTable = symbolTable.adding("    \(symbolName[current])          \(i)         \(symbolScope[current])         \(lineNums[current])") as NSArray
                        
                    } else if  String(describing: i) == "int" {
                        
                        symbolTable = symbolTable.adding("    \(symbolName[current])          \(i)           \(symbolScope[current])          \(lineNums[current])") as NSArray
                        
                    } else if String(describing: i) == "\n" {
                        
                        symbolTable = symbolTable.adding("\n") as NSArray
                        symbolTable = symbolTable.adding("-------------------------------------------") as NSArray
                        symbolTable = symbolTable.adding(" Name | Type | Scope | Line") as NSArray
                        symbolTable = symbolTable.adding("-------------------------------------------") as NSArray
                        
                    } else {
                        
                        print(String(describing: i))
                        
                    }
                    
                    current += 1
                    
                }
                
                for element in symbolTable {
                    
                    symbolList.string?.append(String(describing: element) + "\n")
                    
                }
                
                finalList.append("Program \(String(describing: programNum)) Semantic Analysis Produced (0) errors and (0) warnings\n")
                
            } else {
                
                symbolList.string?.append("not produced due to error(s) detected by semantic analysis\n\n")
                
                for i in errorArray {
                    
                    finalList.append(String(describing: i))
                
                }
                
                finalList.append("Program \(String(describing: programNum)) Semantic Analysis Produced (\(errorCounter)) errors and (0) warnings\n")
                
            }
        
        }
        
    }
    
}
