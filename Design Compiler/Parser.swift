//
//  CST.swift
//  Design Compiler
//
//  Created by Ryan Neumann on 3/6/17.
//  Copyright © 2017 RyanNeumann. All rights reserved.
//
import Foundation

var currentBrace = 0
var quoteMatch = 0
var parenMatch = 0
var parseFinal = [Any]()
var parseList = cleanList
var currentTerm = String()
var cst = [Any]()
var cstIndent = 0
var braceCounter = [Int]()
var parseCount = 0
var statementEnding = 0
var astList = [String]()
var astIndent = 0
var quoteText = ""
var parseError = 0
var typeBool = false
var additionCounter = 0
var currentVar = ""
var original = 0


extension ViewController {
    
    func ParseProgram() {
        //Clears any settings from previous run
        parseList = cleanList
        cleanList.removeAll()
        //parsedList.string?.removeAll()
        //parsedList.string = ""
        parseFinal.removeAll()
        braceCounter = []
        //Initializing Block
        cstIndent = 0
        cst.append("< Program >")
        finalList.append("Parsing program \(programNum)...")
        ParseBlock()
        
        if parseList.isEmpty == false {
            //Skip check if list is empty
            cstIndent -= 1
            cst.append("•[$] ")
            cst.append("**Program \(programNum) completed successfully.**\n")
            currentTerm = "EOP"
            finalList.append("Expecting EOP")
            match(param: "$")
            //print(astList)
            
            if finalList.contains("Parsing completed successfully!") == false {
                
                finalList.insert("Parsing completed successfully!", at: 0)
                
            }
            
        }
        
        for element in cst {
            
            parsedList.string?.append(String(describing: element) + "\n")
            
        }
        
        tokenList.string?.append("\n")
        
        for element in parseFinal {
            //Print final string in Parser box.
            tokenList.string?.append(String(describing: element) + "\n")
            
        }
        
        if cst.isEmpty == false {
            
            for element in astList {
                
                astFinal.string?.append(String(describing: element) + "\n")
                
            }
            
        }
        
    }
    
    func ParseBlock() {
        
        cstIndent += 1
        cst.append(String(repeatElement("•", count: cstIndent))  + "< Block >")
        astList.append(String(repeatElement("-", count: astIndent)) + "< Block >")
        astIndent += 1
        
        finalList.append("Expecting a left brace")
        currentTerm = "left brace"
        match(param: "{")
        ParseStatementList()
        
        if parseList.isEmpty == false {
            
            finalList.append("Expecting a right brace")
            currentTerm = "right brace"
            match(param: "}")
            cstIndent -= 2
            astIndent -= 1
            
        }
        
    }
    
    func ParseStatementList() {
        
        if cstIndent != 0 && parseList.isEmpty == false{
            
            cst.append(String(repeatElement("•", count: cstIndent))  + "< Statement List >")
            
        }
        
        if parseList.isEmpty == false {
            
            if parseList.first! == "}" || parseList.first! == "" || parseList.first! == "$" || parseList.first! == "'"{
                //Do nothing
                if parseList.first! == "}" {
                    
                    cstIndent = statementEnding
                    
                }
                
            } else if (parseList.first! == "\"") {
                
                ParseCharList()
                
            } else {
                
                cstIndent += 1
                cst.append(String(repeatElement("•", count: cstIndent))  + "< Statement >")
                ParseStatement()
                
                if currentTerm != "right brace" && cst.isEmpty == false {
                    
                    cstIndent = statementEnding
                    
                }
                
                ParseStatementList()
                
            }
            
        }
        
    }
    
    func ParseStatement() {
        
        statementEnding = cstIndent
        
        if parseList.isEmpty == false {
            
            if parseList.first! == "print" {
                
                cstIndent += 1
                cst.append(String(repeatElement("•", count: cstIndent))  + "< Print >")
                ParsePrint()
                
            } else if parseList.first! == "int" || parseList.first! == "string" || parseList.first! == "boolean" {
                
                cstIndent += 1
                //symbolType.append(parseList.first!)
                cst.append(String(repeatElement("•", count: cstIndent))  + "< Variable Declaration >")
                finalList.append("Expecting type")
                ParseVarDec()
                
            } else if parseList.first! == "while" {
                
                cstIndent += 1
                cst.append(String(repeatElement("•", count: cstIndent))  + "< While Statement >")
                finalList.append("Expecting while statement")
                ParseWhile()
                
            } else if parseList.first! == "if" {
                
                cstIndent += 1
                cst.append(String(repeatElement("•", count: cstIndent))  + "< If Statement >")
                finalList.append("Expecting if statement")
                
                ParseIf()
                
            } else if acceptedChars.contains(String(describing: parseList.first!)) {
                
                cstIndent += 1
                cst.append(String(repeatElement("•", count: cstIndent))  + "< Assignment >")
                finalList.append("Expecting Id")
                ParseAssignment()
                
            } else if parseList.first! == "{" {
                
                ParseBlock()
                
            } else if parseList.first! == ")" {
                
                currentTerm = "right paren"
                finalList.append("Expecting Right Paren")
                match(param: ")")
                
            } else {
                
                currentTerm = "Statement"
                match(param: "Statement")
                
            }
            
        }
        
    }
    
    func ParseIf() {
        
        astList.append(String(repeatElement("-", count: astIndent)) + "< If Statement >")
        currentTerm = "if"
        match(param: "if")
        ParseBoolean()
        //stack[pointer] = "AE"
        //pointer += 1
        original = pointer
        ParseBlock()
        jumpTable.append(pointer - original)
        
        
    }
    
    func ParseBoolean() {
        
        cstIndent += 1
        cst.append(String(repeatElement("•", count: cstIndent))  + "< Boolean Expression >")
        
        if parseList.first! == "(" {
            
            finalList.append("Expecting left paren")
            currentTerm = "left paren"
            match(param: "(")
            ParseExpr()
            
            if parseList.first! == "==" {
                
                astList.append(String(repeatElement("-", count: astIndent)) + "[ == ]")
                finalList.append("Expecting boolop")
                currentTerm = "boolop"
                match(param: "==")
                ParseExpr()
                
            } else if parseList.first! == "!=" {
                
                astList.append(String(repeatElement("-", count: astIndent)) + "[ != ]")
                finalList.append("Expecting boolop")
                currentTerm = "boolop"
                match(param: "!=")
                ParseExpr()
                
            }  else if parseList.first! == ")"{
                
                finalList.append("Expecting right paren")
                currentTerm = "right paren"
                match(param: ")")
                
            } else if parseList.first! == "{" {
                
                ParseBlock()
                
            }
            
            
            finalList.append("Expecting right paren")
            currentTerm = "right paren"
            match(param: ")")
            
        } else if parseList.first! == "true" {
            
            astList.append(String(repeatElement("-", count: astIndent)) + "[ true ]")
            finalList.append("Expecting boolVal")
            currentTerm = "boolVal"
            if parseList[1] == ")" {
                
                stack[pointer] = "A9"
                pointer += 1
                stack[pointer] = "01"
                pointer += 1
                stack[pointer] = "8D"
                pointer += 1
                if tempTableCounter == 0 {
                    
                    tempTableCounter += 1
                    
                }
                stack[pointer] = "T" + String(describing: tempTableCounter - 1)
                pointer += 1
                stack[pointer] = "00"
                pointer += 1
                
                /* put back in
                 stack[pointer] = "A0"
                 pointer += 1
                 stack[pointer] = "01"
                 pointer += 1
                 stack[pointer] = "A2"
                 pointer += 1
                 stack[pointer] = "01"
                 pointer += 1
                 */
                
            }  else {
                
                stack[pointer] = "A9"
                pointer += 1
                stack[pointer] = "01"
                pointer += 1
                stack[pointer] = "8D"
                pointer += 1
                if tempTableCounter == 0 {
                    
                    tempTableCounter += 1
                    
                }
                stack[pointer] = "T" + String(describing: tempTableCounter - 1)
                pointer += 1
                stack[pointer] = "00"
                pointer += 1
                if parseList[1] == "{" {
                    
                    stack[pointer] = "A2"
                    pointer += 1
                    stack[pointer] = "01"
                    pointer += 1
                    stack[pointer] = "EC"
                    pointer += 1
                    stack[pointer] = "T" + String(describing: tempTableCounter - 1)
                    pointer += 1
                    stack[pointer] = "00"
                    pointer += 1
                    
                    
                    
                    
                    
                }
                
            }
            tempTableCounter += 1
            match(param: "true")
            
        } else if parseList.first! == "false" {
            
            astList.append(String(repeatElement("-", count: astIndent)) + "[ false ]")
            finalList.append("Expecting boolVal")
            currentTerm = "boolVal"
            if parseList[1] == ")" {
                
                stack[pointer] = "A9"
                pointer += 1
                stack[pointer] = "00"
                pointer += 1
                stack[pointer] = "8D"
                pointer += 1
                if tempTableCounter == 0 {
                    
                    tempTableCounter += 1
                    
                }
                stack[pointer] = "T" + String(describing: tempTableCounter - 1)
                pointer += 1
                stack[pointer] = "00"
                pointer += 1
                /*
                 stack[pointer] = "A0"
                 pointer += 1
                 stack[pointer] = "01"
                 pointer += 1
                 stack[pointer] = "A2"
                 pointer += 1
                 stack[pointer] = "01"
                 pointer += 1
                 */
                
            } else {
                
                stack[pointer] = "A9"
                pointer += 1
                stack[pointer] = "00"
                pointer += 1
                stack[pointer] = "8D"
                pointer += 1
                if tempTableCounter == 0 {
                    
                    tempTableCounter += 1
                    
                }
                stack[pointer] = "T" + String(describing: tempTableCounter - 1)
                pointer += 1
                stack[pointer] = "00"
                pointer += 1
                
                if parseList[1] == "{" {
                    
                    stack[pointer] = "A2"
                    pointer += 1
                    stack[pointer] = "01"
                    pointer += 1
                    stack[pointer] = "EC"
                    pointer += 1
                    stack[pointer] = "T" + String(describing: tempTableCounter - 1)
                    pointer += 1
                    stack[pointer] = "00"
                    pointer += 1
                    stack[pointer] = "D0"
                    pointer += 1
                    stack[pointer] = "J" + String(describing: jumpTable.count)
                    pointer += 1
                    
                    
                    
                    
                }
                
                
                
                
            }
            tempTableCounter += 1
            match(param: "false")
            
        } else {
            
            match(param: "Boolean Expression")
            
        }
        
    }
    
    func ParseWhile() {
        
        astList.append(String(repeatElement("-", count: astIndent)) + "< While Statement >")
        finalList.append("- Got while statement!")
        parseList.removeFirst()
        ParseBoolean()
        ParseBlock()
        
    }
    
    func ParseVarDec() {
        
        astList.append(String(repeatElement("-", count: astIndent)) + "< Variable Declaration >")
        astIndent += 1
        finalList.append("- Got type: \(String(describing: parseList.first!))!")
        
        if String(describing: parseList.first!) == "int" {
            
            cstIndent += 1
            cst.append(String(repeatElement("•", count: cstIndent))  + "[ int ]")
            symbolType.append("int")
            stack[pointer] = "A9"
            pointer += 1
            stack[pointer] = "00"
            pointer += 1
            astList.append(String(repeatElement("-", count: astIndent))  + "[ int ]")
            typeBool = true
            
        } else if String(describing: parseList.first!) == "string" {
            
            cstIndent += 1
            cst.append(String(repeatElement("•", count: cstIndent))  + "[ string ]")
            symbolType.append("string")
            stack[pointer] = "A9"
            pointer += 1
            stack[pointer] = "00"
            pointer += 1
            astList.append(String(repeatElement("-", count: astIndent))  + "[ string ]")
            typeBool = true
            
        } else if String(describing: parseList.first!) == "boolean" {
            
            cstIndent += 1
            cst.append(String(repeatElement("•", count: cstIndent))  + "[ boolean ]")
            symbolType.append("bool")
            stack[pointer] = "A9"
            pointer += 1
            stack[pointer] = "00"
            pointer += 1
            astList.append(String(repeatElement("-", count: astIndent))  + "[ boolean ]")
            typeBool = true
            
        }
        
        parseList.removeFirst()
        ParseId()
        astIndent -= 1
        
    }
    
    func ParseId() {
        
        if acceptedChars.contains(String(describing: parseList.first!)) {
            
            if typeBool == false {
                
                //printing
                print("Printing (" + parseList[0] + ")")
                
                scopeChecker(parseList.first!)
                typeChecker(String(describing: parseList.first!))
                
            } else {
                
                
                stack[pointer] = "8D"
                pointer += 1
                stack[pointer] = "T" + String(describing: tempTableCounter)
                pointer += 1
                stack[pointer] = "00"
                pointer += 1

                tempTable[parseList.first! + String(describing: currentBrace - 1)] = ["Name": ("T" + String(describing: tempTableCounter )), "Type": symbolType.last!]
                //tempTable
                
                print(tempTable)
                symbolName.append(parseList.first!)
                scopeChecker(parseList.first!)
                typeBool = false
                tempTableCounter += 1
                
                
            }
            
            finalList.append("Expecting Id")
            cst.append(String(repeatElement("•", count: cstIndent))  + "[ \(String(describing: parseList.first!)) ]")
            astList.append(String(repeatElement("-", count: astIndent))  + "[ \(String(describing: parseList.first!)) ]")
            finalList.append("- Got Id: \(String(describing: parseList.first!))!")
            parseList.removeFirst()
            
        } else {
            
            currentTerm = "Id"
            match(param: "Id")
            
        }
        
    }
    
    func ParseAssignment() {
        
        astList.append(String(repeatElement("-", count: astIndent)) + "< Assignment Statement >")
        astIndent += 1
        astList.append(String(repeatElement("-", count: astIndent)) + "[ \(String(describing: parseList.first!)) ]")
        finalList.append("- Got Id: \(String(describing: parseList.first!))!")
        
        
        if let test = tempTable[parseList[0] + String(describing: currentBrace - 1)] as NSDictionary? {
            
            if let gotName = test["Name"] {
                    
                    currentVar = gotName as! String
            }
        } else if let test = tempTable[parseList[0] + String(describing: currentBrace - 2)] as NSDictionary? {
        
            if let gotName = test["Name"] {
                
                currentVar = gotName as! String
            }
            
        } else if let test = tempTable[parseList[0] + String(describing: currentBrace - 3)] as NSDictionary? {
            
            if let gotName = test["Name"] {
                
                currentVar = gotName as! String
            }
            
        }
        

        
        
        
        
        if acceptedNums.contains(parseList[2]) && parseList[3] != "+"{
            
            print(parseList[0], parseList[1], parseList[2])
            stack[pointer] = "A9"
            pointer += 1
            additionCounter += 1
            stack[pointer] = "0" + parseList[2]
            pointer += 1
            stack[pointer] = "8D"
            pointer += 1
            stack[pointer] = currentVar
            pointer += 1
            tempTableCounter += 1
            stack[pointer] = "00"
            pointer += 1
            
        }
        
        cst.append(String(repeatElement("•", count: cstIndent))  + "[ \(String(describing: parseList.first!)) ]")
        beforeBool = true
        typeChecker(parseList.first!)
        parseList.removeFirst()
        
        if parseList.first == "=" {
            
            finalList.append("Expecting Equals")
            currentTerm = "Equals"
            match(param: "=")
            
        } else if parseList.first == "==" || parseList.first == "!=" {
            
            finalList.append("Expecting BoolOp")
            currentTerm = "BoolOp"
            
            if parseList.first == "==" {
                
                match(param: "==")
                
            } else {
                
                match(param: "!=")
                
            }
            
        }
        
        if parseList.isEmpty == false {
            
            ParseExpr()
            astIndent -= 1
            
        }
        
    }
    
    func ParsePrint() {
        
        astList.append(String(repeatElement("-", count: astIndent)) + "< Print Statement >")
        astIndent += 1
        finalList.append("Expecting Print Statement")
        currentTerm = "print"
        match(param: "print")
        finalList.append("Expecting Left Paren")
        currentTerm = "left paren"
        parenMatch = cstIndent
        match(param: "(")
        
        
        
        if parseList[1] != ")" {
            //print(parseList[2])
            printBool = true
        }
        
        
        ParseExpr()
        stack[pointer] = "FF"
        pointer += 1
        astIndent -= 1
        
        if parseList.isEmpty == false {
            
            currentTerm = "right paren"
            cstIndent = parenMatch
            finalList.append("Expecting Right Paren")
            match(param: ")")
            
        }
        
    }
    
    func ParseExpr() {
        
        cst.append(String(repeatElement("•", count: cstIndent))  + "< Expression >")
        cstIndent += 1
        
        if parseList.isEmpty == false {
            
            if acceptedNums.contains(String(describing: parseList.first!)) {
                
                if parseList[1] == ")"{
                    
                    stack[pointer] = "A0"
                    pointer += 1
                    stack[pointer] = "0" + parseList[0]
                    pointer += 1
                    stack[pointer] = "A2"
                    pointer += 1
                    stack[pointer] = "01"
                    pointer += 1
                    
                } else if acceptedNums.contains(parseList[2]) {
                    
                    stack[pointer] = "A9"
                    pointer += 1
                    additionCounter += 1
                    stack[pointer] = "0" + parseList[0]
                    pointer += 1
                    stack[pointer] = "8D"
                    pointer += 1
                    stack[pointer] = "T" + String(describing: tempTableCounter)
                    pointer += 1
                    tempTableCounter += 1
                    stack[pointer] = "00"
                    pointer += 1
                    stack[pointer] = "A9"
                    pointer += 1
                    stack[pointer] = "0" + parseList[2]
                    pointer += 1
                    stack[pointer] = "8D"
                    additionCounter += 1
                    pointer += 1
                    stack[pointer] = "T" + String(describing: tempTableCounter)
                    tempTableCounter += 1
                    pointer += 1
                    stack[pointer] = "00"
                    pointer += 1
                    
                    if acceptedNums.contains(parseList[4]) == false && parseList[1]  == "+" {
                        stack[pointer] = "A9"
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        var i = 0
                        while i != additionCounter {
                            
                            stack[pointer] = "6D"
                            pointer += 1
                            stack[pointer] = "T" + String(describing: tempTableCounter - i - 1)
                            pointer += 1
                            stack[pointer] = "00"
                            pointer += 1
                            i += 1
                            
                        }
                        
                        stack[pointer] = "8D"
                        pointer += 1
                        stack[pointer] = "T" + String(describing: tempTableCounter)
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "AD"
                        pointer += 1
                        stack[pointer] = "T" + String(describing: tempTableCounter)
                        tempTableCounter += 1
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "8D"
                        pointer += 1
                        stack[pointer] = currentVar
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        
                        
                    }
                    
                    if parseList[1] == "==" {
                        
                        stack[pointer] = "AE"
                        pointer += 1
                        stack[pointer] = "T" + String(describing: tempTableCounter - 2)
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "EC"
                        pointer += 1
                        stack[pointer] = "T" + String(describing: tempTableCounter - 1)
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "A9"
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "8D"
                        pointer += 1
                        stack[pointer] = "T" + String(describing: tempTableCounter)
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "D0"
                        pointer += 1
                        stack[pointer] = "J" + String(describing: jumpTable.count)
                        pointer += 1
                        stack[pointer] = "A9"
                        pointer += 1
                        stack[pointer] = "01"
                        pointer += 1
                        stack[pointer] = "8D"
                        pointer += 1
                        stack[pointer] = "T" + String(describing: tempTableCounter)
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "A2"
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "EC"
                        pointer += 1
                        stack[pointer] = "T" + String(describing: tempTableCounter)
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "D0"
                        pointer += 1
                        stack[pointer] = "J" + String(describing: jumpTable.count)
                        pointer += 1
                        stack[pointer] = "A9"
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "8D"
                        pointer += 1
                        stack[pointer] = "T" + String(describing: tempTableCounter)
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "A2"
                        pointer += 1
                        stack[pointer] = "01"
                        pointer += 1
                        stack[pointer] = "EC"
                        pointer += 1
                        stack[pointer] = "T" + String(describing: tempTableCounter)
                        pointer += 1
                        tempTableCounter += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "D0"
                        pointer += 1
                        stack[pointer] = "J" + String(describing: jumpTable.count)
                        pointer += 1
                        
                        
                    }
                    
                    if parseList[1] == "!=" {
                        
                        stack[pointer] = "AE"
                        pointer += 1
                        stack[pointer] = "T" + String(describing: tempTableCounter - 2)
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "EC"
                        pointer += 1
                        stack[pointer] = "T" + String(describing: tempTableCounter - 1)
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "A9"
                        pointer += 1
                        stack[pointer] = "01"
                        pointer += 1
                        stack[pointer] = "8D"
                        pointer += 1
                        stack[pointer] = "T" + String(describing: tempTableCounter)
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "D0"
                        pointer += 1
                        stack[pointer] = "J" + String(describing: jumpTable.count)
                        pointer += 1
                        stack[pointer] = "A9"
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "8D"
                        pointer += 1
                        stack[pointer] = "T" + String(describing: tempTableCounter)
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "A2"
                        pointer += 1
                        stack[pointer] = "01"
                        pointer += 1
                        stack[pointer] = "EC"
                        pointer += 1
                        stack[pointer] = "T" + String(describing: tempTableCounter)
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "D0"
                        pointer += 1
                        stack[pointer] = "J" + String(describing: jumpTable.count)
                        pointer += 1
                        stack[pointer] = "A9"
                        pointer += 1
                        stack[pointer] = "01"
                        pointer += 1
                        stack[pointer] = "8D"
                        pointer += 1
                        stack[pointer] = "T" + String(describing: tempTableCounter)
                        pointer += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "A2"
                        pointer += 1
                        stack[pointer] = "01"
                        pointer += 1
                        stack[pointer] = "EC"
                        pointer += 1
                        stack[pointer] = "T" + String(describing: tempTableCounter)
                        pointer += 1
                        tempTableCounter += 1
                        stack[pointer] = "00"
                        pointer += 1
                        stack[pointer] = "D0"
                        pointer += 1
                        stack[pointer] = "J" + String(describing: jumpTable.count)
                        pointer += 1
                        
                        
                    }


                    
                    
                } else {
                
    
                
                }
                ParseIntExpr()
                
                
            } else if acceptedChars.contains(String(describing: parseList.first!)) {
                
                if parseList[1] == ")"{
                    
                    //printing a var
                    
                    stack[pointer] = "AC"
                    pointer += 1
                    
                    var currentType = "'"
                    
                    if let test = tempTable[parseList[0] + String(describing: currentBrace - 1)] as NSDictionary? {
                        
                        if let gotName = test["Name"] {
                            
                            currentType = test["Type"] as! String
                            stack[pointer] = gotName as! String
                            pointer += 1
                            stack[pointer] = "00"
                            pointer += 1
                            
                        }
                    } else if let test = tempTable[parseList[0] + String(describing: currentBrace - 2)] as NSDictionary? {
                        
                        if let gotName = test["Name"] {
                            
                            currentType = test["Type"] as! String
                            stack[pointer] = gotName as! String
                            pointer += 1
                            stack[pointer] = "00"
                            pointer += 1
                            
                        }
                        
                    } else if let test = tempTable[parseList[0] + String(describing: currentBrace - 3)] as NSDictionary? {
                        
                        if let gotName = test["Name"] {
                            
                            currentType = test["Type"] as! String
                            stack[pointer] = gotName as! String
                            pointer += 1
                            stack[pointer] = "00"
                            pointer += 1
                        }
                        
                    }
                    
                    stack[pointer] = "A2"
                    pointer += 1
                    
                    if currentType == "string" {
                        
                        stack[pointer] = "02"
                        
                    } else if currentType == "int" {
                        
                        stack[pointer] = "01"
                        
                    } else if currentType == "bool" {
                        
                        stack[pointer] = "01"
                        
                    }
                    pointer += 1
                    
                    
                } else {
                    //parsing if statement
                    if parseList[1] == "!=" {
                    
                        
                    
                    
                    } else if parseList[1] == "==" {
                    
                    
                    
                    
                    }
                    
                }
                ParseId()
                
            } else if parseList.first! == "false" || parseList.first! == "true" || parseList.first! == "(" {
                
                
                ParseBoolean()
                
            }  else if parseList.first! == "while" {
                
                finalList.append("Expecting while statement")
                ParseWhile()
                
            }  else if parseList.first! == "\"" {
                
                ParseStringExpr()
                
            } else {
                
                
                currentTerm = "Expression"
                match(param: "Expression")
                
            }
            
        }
        
    }
    
    func ParseIntExpr() {
        
        cst.append(String(repeatElement("•", count: cstIndent))  + "< Int Expression >")
        cstIndent += 1
        
        if parseList[1] == "+" {
            
            astList.append(String(repeatElement("-", count: astIndent))  + "[ \(String(describing: parseList.first!)) ]")
            astList.append(String(repeatElement("-", count: astIndent)) + "[ + ]")
            finalList.append("Expecting digit")
            finalList.append("- Got digit: \(String(describing: parseList.first!))!")
            cst.append(String(repeatElement("•", count: cstIndent))  + "[ \(String(describing: parseList.first!)) ]")
            parseList.removeFirst()
            finalList.append("Expecting IntOp")
            currentTerm = "IntOp"
            match(param: "+")
            ParseExpr()
            
        } else {
            
            finalList.append("Expecting digit")
            cst.append(String(repeatElement("•", count: cstIndent))  + "[ \(String(describing: parseList.first!)) ]")
            astList.append(String(repeatElement("-", count: astIndent))  + "[ \(String(describing: parseList.first!)) ]")
            finalList.append("- Got digit: \(String(describing: parseList.first!))!")
            parseList.removeFirst()
            
        }
        
    }
    
    func ParseStringExpr() {
        
        cst.append(String(repeatElement("•", count: cstIndent))  + "< String Expression >")
        finalList.append("Expecting open_quote")
        quoteMatch = cstIndent
        currentTerm = "open_quote"
        match(param: "\"")
        ParseCharList()
        finalList.append("Expecting close_quote")
        currentTerm = "close_quote"
        match(param: "\"")
        
    }
    
    func ParseCharList() {
        
        cst.append(String(repeatElement("•", count: cstIndent))  + "< Char List >")
        cstIndent += 1
        
        if parseList.first! != "\"" {
            
            quoteText.append(parseList.first!)
            
        } else {
            
            
            if printBool == true {
                
                
                let asciiString = quoteText.asciiArray
                
                x = x.adding("00") as NSArray
                
                for i in asciiString.reversed() {
                    
                    x = x.adding(NSString(format:"%02X", i)) as NSArray
                    
                }
                
                
                stack[pointer] = "A0"
                pointer += 1
                stack[pointer] = NSString(format:"%02X", 256 - x.count) as String
                pointer += 1
                stack[pointer] = "A2"
                pointer += 1
                stack[pointer] = "02"
                pointer += 1
                
            }
            
            printBool = false
            astList.append(String(repeatElement("-", count: astIndent))  + "[ \(quoteText) ]")
            quoteText = ""
            
            
        }
        
        if acceptedChars.contains(String(describing: parseList.first!)) {
            
            finalList.append("Expecting char")
            cst.append(String(repeatElement("•", count: cstIndent))  + "[ \(String(describing: parseList.first!)) ]")
            finalList.append("- Got char: \(String(describing: parseList.first!))!")
            parseList.removeFirst()
            ParseCharList()
            
        } else if parseList.first! == " " {
            
            cst.append(String(repeatElement("•", count: cstIndent))  + "[ \(String(describing: parseList.first!)) ]")
            finalList.append("Expecting potential white space")
            finalList.append("- Got white space!")
            parseList.removeFirst()
            ParseCharList()
            
        } else {
            //Do nothing
        }
        
    }
    
    func match(param: Any) {
        
        if parseList.isEmpty == false {
            
            if String(describing: param) == parseList.first! {
                
                if String(describing: param) == "}" {
                    
                    currentBrace -= 1
                    cstIndent = braceCounter[currentBrace]
                    cst.append(String(repeatElement("•", count: braceCounter[currentBrace] ))  + "[ " + String(describing: param) + " ]")
                    
                }
                
                if String(describing: param) == "\"" {
                    
                    cst.append(String(repeatElement("•", count: quoteMatch))  + "[ " + String(describing: param) + " ]")
                    
                }
                
                if String(describing: param) == "$" {
                    
                    cstIndent -= 1
                    
                }
                
                
                if String(describing: param) != "$" && String(describing: param) != "Statement List" && String(describing: param) != "}" && String(describing: param) != "\""{
                    
                    if String(describing: param) == "{" {
                        
                        cstIndent += 1
                        braceCounter.insert(cstIndent, at: currentBrace)
                        cst.append(String(repeatElement("•", count: braceCounter[currentBrace] ))  + "[ " + String(describing: param) + " ]")
                        currentBrace += 1
                        
                    } else {
                        
                        cst.append(String(repeatElement("•", count: cstIndent))  + "[ " + String(describing: param) + " ]")
                        
                    }
                    
                }
                
                finalList.append("- Got \(currentTerm)!")
                parseList.removeFirst()
                
                if currentTerm == "EOP" {
                    
                    finalList.append("Program \(parseCount) completed successfully!\n")
                    parseCount += 1
                    
                }
                
            } else {
                
                if currentTerm == "EOP" {
                    
                    finalList.append("- Got EOP")
                    finalList.append("Program \(parseCount) completed successfully!\n")
                    parseCount += 1
                    
                } else {
                    
                    
                    parseError += 1
                    finalList.append("\nError - Expecting \(currentTerm).  Instead got \(String(describing: parseList.first!))\n")
                    astList.removeAll()
                    parseFinal.removeAll()
                    parseList.removeAll()
                    cst.removeAll()
                    
                }
            }
            
        }
        
    }
    
}
