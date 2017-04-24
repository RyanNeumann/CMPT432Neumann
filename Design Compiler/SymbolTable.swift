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
var lineNums = [Int]()
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
                
                var indexCheck = symbolName.index(of: parseList[0])
                
                if symbolType[indexCheck!] != "int" {
                    
                    while symbolType.count > indexCheck! || symbolType[indexCheck! - 1] != "int" {
                        
                        indexCheck! += 1
                        
                    }
                    
                    if (symbolType[indexCheck! - 1] == "int" && symbolName[indexCheck! - 1] == parseList[0]  && symbolScope[indexCheck! - 1] as! Int >= scopeTracker) {
                        
                        //Do Nothing
                        if parseList[3] == "+" && parseList[4] == "\"" {
                            
                            typeErrors.append("Error: Type mismatch with \(t) \(parseList[1]) \(parseList[2]) \(parseList[3]) \(parseList[4])\n")
                            errorCounter += 1
                            
                        }

                        
                    } else {
                        
                        
                        typeErrors.append("Error: Type mismatch with \(t) \(parseList[1]) \(parseList[2])\n")
                        errorCounter += 1
                        
                    }
                    
                    
                } else {
                
                    if parseList[3] == "+" && parseList[4] == "\"" {
                        
                        typeErrors.append("Error: Type mismatch with \(t).  It is an int, not a string!")
                        errorCounter += 1
                        
                    }
                
                }
                
            } else {
                
                if acceptedChars.contains(parseList[2]) {
                    
                    if symbolName.contains(parseList[2]) {
                       
                        if var index = symbolName.index(of: parseList[2]){
                        
                            if var indexCheck = symbolName.index(of: t){
                            
                                if symbolType[indexCheck] == symbolType[index] {
                                    
                                    if (symbolScope[indexCheck] as! Int >= symbolScope[index] as! Int) == false {
                                        
                                        typeErrors.append("Error: Scope out of bounds for \(t)\n")
                                        errorCounter += 1
                                        
                                    } else {
                                        
                                        while symbolScope[index] as! Int != currentBrace || symbolName[index] != parseList[2] {
                                        
                                            if symbolScope[index] as! Int > currentBrace {
                                            
                                                index -= 1
                                            
                                            } else {
                                            
                                                index += 1
                                            
                                            }
                                           
                                            symbolType[indexCheck] = symbolType[index]
                                            
                                        }
                                        
                                    
                                    }
                                    
                                } else {
                                    
                                    //testing parseList[0] to see if it exists
                                    
                                    if symbolName.contains(parseList[0]) {
                                        //symbol exists
                                        var index = symbolName.index(of:  parseList[0])
                                        var index2 = symbolName.index(of:  parseList[2])
                                        if symbolName.contains(parseList[2]) {
                                            
                                                while symbolScope[index2!] as! Int != currentBrace {
                                                    
                                                    if symbolScope[index2!] as! Int > currentBrace {
                                                    
                                                        index2! -= 1
                                                    
                                                    } else {
                                                    
                                                        index2! += 1
                                                    
                                                    }
                                            
                                                }
                                            
                                                if symbolName[symbolName.index(of: parseList[2])!] == symbolName[index2!] {
                                                    
                                                    symbolType[index!] = symbolType[index2!]
                                                    print("working")
                                                    
                                                } else {
                                                    
                                                    typeErrors.append("Error: Scope out of bounds for \(t)\n")
                                                    errorCounter += 1
                                                
                                                }
                                                    
                                                    
                                                
                                                
                                            
                                            
                                        } else {
                                        
                                            typeErrors.append("Error: Scope out of bounds for \(t)\n")
                                            errorCounter += 1
                                        
                                        }
                                    
                                    
                                    
                                    } else {
                                        //scope out of bounds
                                        typeErrors.append("Error: Scope out of bounds for \(t)\n")
                                        errorCounter += 1
                                        
                                    
                                    }
                                    
                                    
                                    
                                }
                            
                            } else {
                                
                                typeErrors.append("Error: Scope out of bounds for \(t)\n")
                                errorCounter += 1
                                
                            }
                            
                        } else {
                            
                            typeErrors.append("Error: Scope out of bounds for \(t)\n")
                            errorCounter += 1
                            
                        }
                        
                    } else {
                        
                        typeErrors.append("Error: id: \(parseList[2]) not in scope\n")
                        errorCounter += 1
                        
                    }
                
                } else {
                
                    if parseList[2] == "\"" {
                    
                        var indexCheck = symbolName.index(of: parseList[0])
                        
                        if symbolType[indexCheck!] != "string" {
                        
                            if indexCheck == 0 {
                            
                            
                            } else {
                            
                                indexCheck! -= 1
                            
                            }
                            
                            while symbolType.count > indexCheck! && symbolType[indexCheck!] != "string" {
                            
                                indexCheck! += 1
                            
                            }
                        
                            if (symbolType[indexCheck! - 1] == "string" && symbolName[indexCheck! - 1] == parseList[0]  && symbolScope[indexCheck! - 1] as! Int >= scopeTracker) {
                            
                            
                            //Do Nothing
                            
                            } else {
                                
                                
                                typeErrors.append("Error: Type mismatch with \(t) \(parseList[1]) \(parseList[2])\n")
                                errorCounter += 1
                                
                            }
                        
                        }
                        
                    }
                    
                }
                
            }
            
        }
    
    }
    
    func produceSymbolTable () {
        
        if test[programNum] == nil {
            
            test.updateValue(false, forKey: programNum)
            
        }
        
        if errorCounter == 0  {
            
            if test[programNum] == false {
                
                var current = 0
                
                if symbolType.count > 0 {
                    
                    symbolTable.append("-----------------------------------")
                    symbolTable.append(" Name | Type | Scope | Line")
                    symbolTable.append("-----------------------------------")
                    
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
                        
                        symbolTable.append("    \(symbolName[current])        \(i)      \(symbolScope[current])          \(lineNums[current])")
                        
                    } else if  String(describing: i) == "bool" {
                        
                        symbolTable.append("    \(symbolName[current])        \(i)        \(symbolScope[current])          \(lineNums[current])")
                        
                    } else if  String(describing: i) == "int" {
                        
                        symbolTable.append("    \(symbolName[current])        \(i)          \(symbolScope[current])          \(lineNums[current])")
                        
                    } else if String(describing: i) == "\n" {
                        
                        symbolTable.append("\n")
                        symbolTable.append("-----------------------------------")
                        symbolTable.append(" Name | Type | Scope | Line")
                        symbolTable.append("-----------------------------------")
                        
                        
                    } else {
                        
                        print(String(describing: i))
                        
                    }
                    
                    current += 1
                    
                }
                
                if parseError == 0 {
                
                    for element in symbolTable {
                    
                        symbolList.string?.append(String(describing: element) + "\n")
                    
                    }
                
                }
                symbolList.string?.append("**Program \(programNum) completed successfully.**\n")
                
                if finalList.contains("Semantic Analysis completed successfully!\n") == false {
                    
                    if let index = finalList.index(of: "Parsing completed successfully!") {
                    
                        finalList.insert("Semantic Analysis completed successfully!\n", at: index + 1)
                        
                    }
                    
                }
                
                finalList.append("Program \(String(describing: programNum)) Semantic Analysis Produced (0) errors and (0) warnings\n")
                
            } else {
                
                symbolList.string?.append("not produced due to error(s) detected by semantic analysis\n")
                
                for i in errorArray {
                    
                    finalList.append(String(describing: i))
                    
                }
                
                finalList.append("Program \(String(describing: programNum)) Semantic Analysis Produced (\(scopeErrors)) errors and (0) warnings\n")
                
            }
         
        } else {
        
            for i in typeErrors {
            
                finalList.append(i)
            
            }
    
            symbolList.string?.append("not produced due to error(s) detected by semantic analysis\n")
            finalList.append("Program \(String(describing: programNum)) Semantic Analysis Produced (\(typeErrors.count)) errors and (0) warnings\n")
            
        }
        
    }
    
}
