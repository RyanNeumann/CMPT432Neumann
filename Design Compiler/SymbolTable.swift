//
// SymbolTable.swift
//  Design Compiler
//
//  Created by Ryan Neumann on 4/9/17.
//  Copyright © 2017 RyanNeumann. All rights reserved.
//

import Foundation

var symbolName = [String]()
var symbolType = [String]()
var lineNums: NSArray = []
var symbolScope: NSArray = []
var symbolTable = [String]()
var scopeTracker = 0
var scopeBool = true
var scopeErrors = 0
var test = [Int:Bool]()
var errorArray: NSArray = []
var errorCounter = 0
var beforeBool = false
var typeErrors = [String]()

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
                
                errorArray = errorArray.adding("Error: the id \(a) on line \(currentLine) was used before being declared.") as NSArray
                scopeErrors += 1
                test.updateValue(true, forKey: programNum)
            
            } else {
            
                if test[programNum] != true {
                
                    test.updateValue(false, forKey: programNum)
                    
                }
                
            }

    }
    
    func typeChecker(_ t: String) {
        
        if beforeBool == true {
        
            if acceptedNums.contains(parseList[2]) {
                let idIntScope = symbolName.index(of: t)
                
                if idIntScope != nil {
                    
                if String(describing: symbolType[idIntScope!]) != "int" {
                    
                    symbolList.string?.append("Program \(programNum) Symbol Table\n")
                    symbolList.string?.append("Error: Type mismatch with \(t) \(parseList[1]) \(parseList[2])\n")
                    errorCounter += 1
                
                } else {
                
                    
                
                }
                    
        }
        
                
            } else {
                
                if acceptedChars.contains(parseList[2]) {
                    
                    if symbolName.contains(parseList[2]) {
                       
                        
                        
                        if let index = symbolName.index(of: parseList[2]) {
                        
                            if let indexCheck = symbolName.index(of: t){
                            
                                if symbolType[indexCheck] == symbolType[index] {
                                    
                                    if (symbolScope[indexCheck] as! Int >= symbolScope[index] as! Int) == false {
                                        
                                        symbolList.string?.append("Program \(programNum) Symbol Table\n")
                                        symbolList.string?.append("Error: Scope out of bounds for \(t)\n")
                                        
                                    }
                                    
                                } else {
                                    
                                    let test = symbolName.index(of: t)
                                    let name = symbolName[test!]
                                    let targetLocation = symbolName.index(of: parseList[2])
                                    symbolType[test!] = symbolType[targetLocation!]
                                    
                                    
                                }
                            
                            } else {
                            
                            symbolList.string?.append("Program \(programNum) Symbol Table\n")
                            symbolList.string?.append("Error: Scope out of bounds for \(t)\n")
                            errorCounter += 1
                            
                            }
                            
                        } else {
                        
                            symbolList.string?.append("Program \(programNum) Symbol Table\n")
                            symbolList.string?.append("Error: Scope out of bounds for \(t)\n")
                            errorCounter += 1
                        
                        }
                        
                    } else {
                        
                        symbolList.string?.append("Program \(programNum) Symbol Table\n")
                        symbolList.string?.append("Error: id: \(parseList[2]) not in scope\n")
                        errorCounter += 1
                        
                        
                    }
                
                } else {
                
                    if parseList[2] == "\"" {
                    
                        let indexCheck = symbolName.index(of: t)
                        if indexCheck != nil {
                            
                            if String(describing: symbolType[indexCheck!]) != "string" {
                                
                                errorCounter += 1
                                symbolList.string?.append("Program \(programNum) Symbol Table\n")
                                symbolList.string?.append("Error: Type mismatch with id: \(t)")
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        } else {
        
            print(parseList)
        
        }
    
    }
    
    func produceSymbolTable () {
        
        if test[programNum] == nil {
            
            test.updateValue(false, forKey: programNum)
            
        }
        
        if errorCounter == 0  {
            
            if test[programNum] == false {
                
                symbolList.string?.append("Program \(programNum) Symbol Table\n")
                var current = 0
                
                if symbolType.count > 0 {
                    
                    symbolTable.append("-------------------------------------------")
                    symbolTable.append(" Name | Type | Scope | Line")
                    symbolTable.append("-------------------------------------------")
                    
                }
                
                for i in symbolType {
                    
                    var count = 3
                    for cont in symbolTable {
                        
                        if String(describing: cont).replacingOccurrences(of: " ", with: "").contains("\(symbolName[current])\(i)\(symbolScope[current])") {
                            
                            symbolTable.remove(at: count - 3)
                            
                        } else {
                            
                            count += 1
                            
                        }
                        
                    }
                    
                    if  String(describing: i) == "string" {
                        
                        symbolTable.append("    \(symbolName[current])         \(i)      \(symbolScope[current])          \(lineNums[current])")
                        
                    } else if  String(describing: i) == "bool" {
                        
                        symbolTable.append("    \(symbolName[current])         \(i)         \(symbolScope[current])         \(lineNums[current])")
                        
                    } else if  String(describing: i) == "int" {
                        
                        symbolTable.append("    \(symbolName[current])         \(i)           \(symbolScope[current])          \(lineNums[current])")
                        
                    } else if String(describing: i) == "\n" {
                        
                        symbolTable.append("\n")
                        symbolTable.append("-------------------------------------------")
                        symbolTable.append(" Name | Type | Scope | Line")
                        symbolTable.append("-------------------------------------------")
                        
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
                
                symbolList.string?.append("Program \(programNum) Symbol Table\n")
                symbolList.string?.append("not produced due to error(s) detected by semantic analysis\n\n")
                
                for i in errorArray {
                    
                    finalList.append(String(describing: i))
                    
                }
                
                finalList.append("Program \(String(describing: programNum)) Semantic Analysis Produced (\(scopeErrors)) errors and (0) warnings\n")
                
            }
        
        } else {
        
            finalList.append("Program \(String(describing: programNum)) Semantic Analysis Produced (\(errorCounter)) errors and (0) warnings\n")
            //type mismatch
        
        }
        
        }
    
}
