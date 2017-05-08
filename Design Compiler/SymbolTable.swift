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
var scopeTracker = -1
var scopeBool = true
var errorArray: NSArray = []
var beforeBool = false
var typeErrors = [String]()

extension ViewController {

    func scopeChecker (_ a: String) {
        
        var testArray: NSArray = []
        var x = 0
        
        for g in symbolName {
            
            if testArray.contains(String(describing: g) + "," + String(describing: symbolScope[x])) {
            
                if errorArray.contains("Scope Error: Id \(g) is already defined.") == false {
                  
                    errorArray = errorArray.adding("Scope Error: Id \(g) is already defined.") as NSArray
                    
                }

            
            } else {
            
                testArray = testArray.adding(String(describing: g) + "," + String(describing: symbolScope[x])) as NSArray
                x += 1
            }
        }
    
        
            var scope = currentBrace - 1
            
            while scope > -1 {
            
                if testArray.contains("\(a),\(scope)") {
                
                    scopeBool = false
                    break
                
                } else {
                  
                    scopeBool = true
                    scope -= 1
                    
                }
            }
        
        
            if scopeBool == true {
                
                errorArray = errorArray.adding("Scope Error: the id \(a) on line \(currentLine) was used before being declared.") as NSArray
            
            } 
        
        
    }
    
    func typeChecker(_ t: String) {
        
            if acceptedNums.contains(parseList[2]) {
                
                var indexCheck = symbolName.index(of: t)
                
                if symbolType[indexCheck!] != "int" {
                    
                    
                    while symbolType[indexCheck!] != "int" {
                        
                        
                        if symbolType.count > (indexCheck! + 1) {
                            
                            indexCheck! += 1
                            
                        } else {
                            
                            indexCheck! -= 1
                            break
                            
                        }
                        
                    }
                    
                
                    if (symbolType[indexCheck!] == "int" && symbolName[indexCheck!] == t && symbolScope[indexCheck!] as! Int >= scopeTracker) {
                        
                        
                        //Do Nothing
                        if parseList[3] == "+" && parseList[4] == "\"" {
                            
                            typeErrors.append("Error: Type mismatch with \(t) \(parseList[1]) \(parseList[2]) \(parseList[3]) \(parseList[4])\n")
                            
                        }

                        print(parseList)
                        
                    } else {
                        
                        
                        typeErrors.append("Error: Type mismatch with \(t) \(parseList[1]) \(parseList[2])\n")
                        
                    }
                    
                    
                } else {
                
                    if parseList[3] == "+" && parseList[4] == "\"" {
                        
                        typeErrors.append("Error: Type mismatch with \(t).  It is an int, not a string!")
                        
                    } else {
                    
                        if parseList[3] == "+" && acceptedChars.contains(parseList[4]){
                                
                                print(parseList[4])
                                stack[pointer] = "A9"
                                pointer += 1
                                stack[pointer] = "0" + parseList[2]
                                pointer += 1
                                stack[pointer] = "8D"
                                pointer += 1
                                stack[pointer] = "T" + (String(describing: tempTableCounter))
                                pointer += 1
                                tempTableCounter += 1
                                stack[pointer] = "00"
                                pointer += 1
                                stack[pointer] = "A9"
                                pointer += 1
                                stack[pointer] = "00"
                                pointer += 1
                                stack[pointer] = "6D"
                                pointer += 1
                                if let test = tempTable[parseList[4]] as? NSDictionary {
                                    if let test2 = test[currentBrace-1] as? NSDictionary {
                                        if let gotName = test2["Name"] {
                                            
                                            stack[pointer] = gotName as! String
                                            pointer += 1
                                            stack[pointer] = "00"
                                            pointer += 1
                                        }
                                    } else if let test2 = test[currentBrace-2] as? NSDictionary {
                                        if let gotName = test2["Name"] {
                                            
                                            stack[pointer] = gotName as! String
                                            pointer += 1
                                            stack[pointer] = "00"
                                            pointer += 1
                                        }
                                    } else if let test2 = test[currentBrace-3] as? NSDictionary {
                                        if let gotName = test2["Name"] {
                                            
                                            stack[pointer] = gotName as! String
                                            pointer += 1
                                            stack[pointer] = "00"
                                            pointer += 1
                                        }
                                    }
                                }
                                stack[pointer] = "6D"
                                pointer += 1
                                stack[pointer] = "T" + (String(describing: tempTableCounter-1))
                                pointer += 1
                                stack[pointer] = "00"
                                pointer += 1
                                stack[pointer] = "8D"
                                pointer += 1
                                stack[pointer] = "T" + (String(describing: tempTableCounter))
                                pointer += 1
                                stack[pointer] = "00"
                                pointer += 1
                                stack[pointer] = "AD"
                                pointer += 1
                                stack[pointer] = "T" + (String(describing: tempTableCounter))
                                pointer += 1
                                stack[pointer] = "00"
                                pointer += 1
                                stack[pointer] = "8D"
                                pointer += 1
                                
                                if let test = tempTable[parseList[0]] as? NSDictionary {
                                    if let test2 = test[currentBrace-1] as? NSDictionary {
                                        if let gotName = test2["Name"] {
                                            
                                            stack[pointer] = gotName as! String
                                            pointer += 1
                                            stack[pointer] = "00"
                                            pointer += 1
                                        }
                                    } else if let test2 = test[currentBrace-2] as? NSDictionary {
                                        if let gotName = test2["Name"] {
                                            
                                            stack[pointer] = gotName as! String
                                            pointer += 1
                                            stack[pointer] = "00"
                                            pointer += 1
                                        }
                                    } else if let test2 = test[currentBrace-3] as? NSDictionary {
                                        if let gotName = test2["Name"] {
                                            
                                            stack[pointer] = gotName as! String
                                            pointer += 1
                                            stack[pointer] = "00"
                                            pointer += 1
                                            
                                        }
                                    }
                                }
                                
                                
                                tempTableCounter += 1

                    

                        } else if parseList[3] == "+" && acceptedNums.contains(parseList[4]){
                        
                        
                        
                        } else {
                        
                        //ASSIGNING VARIABLE TO INTEGER
                        stack[pointer] = "A9"
                        pointer += 1
                        stack[pointer] = "0" + parseList[2]
                        pointer += 1
                         print(parseList[2])
                        stack[pointer] = "8D"
                        pointer += 1
                        
                        if let test = tempTable[parseList.first!] as? NSDictionary {
                            if let test2 = test[currentBrace-1] as? NSDictionary {
                                if let gotName = test2["Name"] {
                        
                                    stack[pointer] = gotName as! String
                                    pointer += 1
                                    stack[pointer] = "00"
                                    pointer += 1
                                }
                            } else if let test2 = test[currentBrace-2] as? NSDictionary {
                                if let gotName = test2["Name"] {
                                    
                                    stack[pointer] = gotName as! String
                                    pointer += 1
                                    stack[pointer] = "00"
                                    pointer += 1
                                }
                            } else if let test2 = test[currentBrace-3] as? NSDictionary {
                                if let gotName = test2["Name"] {
                                    
                                    stack[pointer] = gotName as! String
                                    pointer += 1
                                    stack[pointer] = "00"
                                    pointer += 1
                                }
                            }
                        }
                            
                            
                    }
                    }
                    
                }
                
            } else {
                
                if acceptedChars.contains(parseList[2]) {
                    
                    if symbolName.contains(parseList[2]) {
                        
                        var test1 = [String]()
                        var x = 0
                        for g in symbolName{
                            
                            test1.append(g + "," + String(describing: symbolScope[x]))
                            x += 1
                            
                        }
                        
                        if test1.contains(parseList[2] + "," + String(describing: (currentBrace - 1))) {
                        
                            let index = test1.index(of: (parseList[2] + "," + String(describing: (currentBrace - 1))))
                            let index2 = symbolName.index(of: parseList[0])
                            if symbolType[index!] != symbolType[index2!] {
                            
                                if errorArray.count == 0 {
                                typeErrors.append("Error: Type mismatch.  id: \(parseList[0]) is a(n) \(symbolType[index2!]), while id: \(parseList[2]) is a(n) \(symbolType[index!])")
                                }
                            }
                        }
                       
                        if var index = symbolName.index(of: parseList[2]){
                        
                            if let indexCheck = symbolName.index(of: t){
                            
                                if symbolType[indexCheck] == symbolType[index] {
                                    if (symbolScope[indexCheck] as! Int >= symbolScope[index] as! Int) == false {
                                        
                                        
                                        print(parseList[0])
                                        //typeErrors.append("Error: \(parseList[2]) is out of scope in \(t, parseList[1], parseList[2]).")
                                        
                                    } else {
                                        
                                        while symbolScope[index] as! Int != currentBrace && symbolName[index] != parseList[2] {
                               
                                            if symbolScope[index] as! Int > (currentBrace) {
                                            
                                                index -= 1
                                            
                                            } else {
                                            
                                                index += 1
                                            
                                            }
                                            
                                            symbolType[indexCheck] = symbolType[index]
                                            
                                        }
                                        
                                    
                                    }
                                    
                                } else {
                                    
                                    //testing parseList[0] to see if it exists
                                    
                                    if symbolName.contains(t) {
                                        //symbol exists
                                        let index = symbolName.index(of:  t)
                                        var index2 = symbolName.index(of:  parseList[2])
                                        if symbolName.contains(parseList[2]) {
                                            
                                                while symbolScope[index2!] as! Int != (currentBrace - 1) {
                                                    
                                                    if symbolScope[index2!] as! Int > (currentBrace - 1) {
                                                    
                                                        index2! -= 1
                                                    
                                                    } else {
                                                    
                                                        index2! += 1
                                                    
                                                    }
                                            
                                                }
                                            
                                                if symbolName[symbolName.index(of: parseList[2])!] == symbolName[index2!] {
                                                    
                                                    if symbolType[index!] != symbolType[index2!]  {
                                                        if errorArray.count == 0 {
                                                        typeErrors.append("Error: Type mismatch.  id: \(t) is a(n) \(symbolType[index!]), while id: \(parseList[2]) is a(n) \(symbolType[index2!])")
                                                        }
                                                    } else {
                                                
                                                    
                                                    }
                                                } else {
                                                    
                                                    
                                                    typeErrors.append("Error: Scope out of bounds for \(t)\n")
                                                    
                                                
                                                }
                                                    
                                                    
                                                
                                                
                                            
                                            
                                        } else {
                                        
                                            typeErrors.append("Error: Scope out of bounds for \(parseList[2])\n")

                                        
                                        }
                                    
                                    
                                    
                                    } else {
                                        //scope out of bounds
                                        
                                        typeErrors.append("Error: Scope out of bounds for \(t)\n")
                                        
                                        
                                    
                                    }
                                    
                                    
                                    
                                }
                            
                            } else {
                                
                                typeErrors.append("Error: Scope out of bounds for \(t)\n")
                                
                            }
                            
                        } else {
                            
                            
                            typeErrors.append("Error: Scope out of bounds for \(parseList[2])\n")
                            
                        }
                        
                    } else {
                        
                        print(parseList)
                        typeErrors.append("Error: id: \(parseList[2]) not in scope\n")
                        
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

                                print(parseList[0]+"Here")
                            //Do Nothing
                            
                            } else {
                                
                                
                                typeErrors.append("Error: Type mismatch with \(t) \(parseList[1]) \(parseList[2])\n")
                                
                            }
                        
                        } else {
                            //It is a string
                            
                            if parseList[2] == "\"" {
                                var completeString = ""
                                var indexOf = 3
                                
                                while parseList[indexOf] != "\"" {
                                
                                    completeString.append(parseList[indexOf])
                                    indexOf += 1
                                
                                }
                                
                                
                                x = x.adding("00") as NSArray
                                let asciiString = completeString.asciiArray
                                print(completeString + "HERE")
                                for i in asciiString.reversed() {
                                
                                    
                                   x = x.adding(NSString(format:"%02X", i)) as NSArray
                                
                                }
                                

                                stack[pointer] = "A9"
                                pointer += 1
                                stack[pointer] = NSString(format:"%02X", 256 - x.count) as String
                                pointer += 1
                                stack[pointer] = "8D"
                                pointer += 1
                                if let test = tempTable[parseList.first!] as? NSDictionary {
                                    if let test2 = test[currentBrace-1] as? NSDictionary {
                                        if let gotName = test2["Name"] {
                                            
                                            stack[pointer] = gotName as! String
                                            pointer += 1
                                            stack[pointer] = "00"
                                            pointer += 1
                                        }
                                    } else if let test2 = test[currentBrace-2] as? NSDictionary {
                                        if let gotName = test2["Name"] {
                                            
                                            stack[pointer] = gotName as! String
                                            pointer += 1
                                            stack[pointer] = "00"
                                            pointer += 1
                                        }
                                    } else if let test2 = test[currentBrace-3] as? NSDictionary {
                                        if let gotName = test2["Name"] {
                                            
                                            stack[pointer] = gotName as! String
                                            pointer += 1
                                            stack[pointer] = "00"
                                            pointer += 1
                                        }
                                    }
                                }
 
                            
                            }
                            
                        
                        }
                        
                    }
                    
                }
                
            }
    
    }
    
    func produceSymbolTable () {
        var current = 0
        
        if symbolType.count > 0 {
                    
            symbolTable.append("-----------------------------------")
            symbolTable.append(" Name | Type | Scope | Line")
            symbolTable.append("-----------------------------------")
                    
        }
        
        
        for i in symbolType {
            
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
                
                
                
            }
            
            current += 1
        }
        
        
        if errorArray.count > 0 || typeErrors.count > 0 {
        
            for i in errorArray {
                    
                finalList.append(String(describing: i))
                    
            }
                
            
            
                for i in typeErrors {
                    
                    finalList.append(i)
                    
               }
                
            
              symbolList.string?.append("not produced due to error(s) detected by semantic analysis\n")
            
              finalList.append("Program \(String(describing: programNum)) Semantic Analysis Produced (\(errorArray.count + typeErrors.count)) errors and (0) warnings\n")
            
            } else {
            
            if parseError == 0 {
                
                    for element in symbolTable {
                    
                        symbolList.string?.append(String(describing: element) + "\n")
                    
                    }
                
                }
                symbolList.string?.append("**Program \(programNum) completed successfully.**\n")
                
                if finalList.contains("Semantic Analysis completed successfully!\n") == false {
                    
                    if let index = finalList.index(of: "Parsing completed successfully!") {
                    
                        finalList.insert("Semantic Analysis completed successfully!\n", at: index + 1)
                        printAcc()
                        
                    }
                    
                }
                
                finalList.append("Program \(String(describing: programNum)) Semantic Analysis Produced (0) errors and (0) warnings\n")
            

        }
        
    }
    
}
