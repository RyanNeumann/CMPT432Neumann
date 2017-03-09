//
//  CST.swift
//  Design Compiler
//
//  Created by Ryan Neumann on 3/6/17.
//  Copyright © 2017 RyanNeumann. All rights reserved.
//

import Foundation

var quoteMatch = 0
var parseFinal = [Any]()
var parseList = cleanList
var currentTerm = String()
var cst = [Any]()
var cstIndent = 0
var braceCounter = 0
var parseCount = 0
var statementEnding = 0

extension ViewController {
    
    
    func ParseProgram() {
        //Clears any settings from previous run
        parseList = cleanList
        cleanList.removeAll()
        parsedList.string?.removeAll()
        parsedList.string = ""
        parseFinal.removeAll()
        braceCounter = 0
        //Initializing Block
        cstIndent = 0
        cst.append("< Program >")
        finalList.append("Parsing program \(parseCount)...")
        ParseBlock()
        
        
        if parseList.isEmpty == false {
            //Skip check if list is empty
            cstIndent -= 1
            cst.append("•[$]\n ")
            currentTerm = "EOP"
            finalList.append("Expecting EOP")
            match(param: "$")
            
            if finalList.contains("Parsing completed successfully.\n") == false {
                print("here")
                finalList.insert("Parsing completed successfully.\n", at: 0)
            
            }
        }
        
        parsedList.string = ""
        var lineNumber = 0
        
        for element in cst {
        
            parsedList.string?.append(String(describing: element) + "\n")
        
        }
        
        
        tokenList.string?.append("\n")
        
        for element in parseFinal {
            //Print final string in Parser box.
            tokenList.string?.append(String(describing: element) + "\n")
            lineNumber += 1
            
        }
    
    }

    func ParseBlock() {
        
        cstIndent += 1
        cst.append(String(repeatElement("•", count: cstIndent))  + "< Block >")
        finalList.append("Expecting a left brace")
        currentTerm = "left brace"
        match(param: "{")
        braceCounter = cstIndent
        
        cst.append(String(repeatElement("•", count: cstIndent))  + "< Statement List >")
        ParseStatementList()
        
        if parseList.isEmpty == false {
            
            finalList.append("Expecting a right brace")
            currentTerm = "right brace"
            match(param: "}")

        }
    }
    
    
    
    func ParseStatementList() {
        
        if parseList.isEmpty == false {
            
            if parseList.first! == "}" || parseList.first! == "" || parseList.first! == "$" || parseList.first! == "\"" || parseList.first! == "'"{
                
                
                
            } else {
                
                
                    cstIndent += 1
                    statementEnding = cstIndent
                    cst.append(String(repeatElement("•", count: cstIndent))  + "< Statement >")
                    ParseStatement()
                
                print(currentTerm)
                if currentTerm != "right brace" && cst.isEmpty == false {
                    
                    cst.append(String(repeatElement("•", count: statementEnding))  + "< Statement List >")
                    cstIndent = statementEnding
                    
                }
                
                ParseStatementList()
            }
            
        }
        
    }

    func ParseStatement() {
        
        if parseList.isEmpty == false {
        
            print(parseList)
            if parseList.first! == "print" {
                cstIndent += 1
                cst.append(String(repeatElement("•", count: cstIndent))  + "< Print >")
                ParsePrint()
                
            } else if parseList.first! == "int" || parseList.first! == "string" || parseList.first! == "boolean" {
                
                cstIndent += 1
                cst.append(String(repeatElement("•", count: cstIndent))  + "< Var Decl >")
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
                
            } else {
            
                currentTerm = "Statement"
                match(param: "Statement")
            
            }
        
        }
        
    }
    
    func ParseIf() {
        
        
        currentTerm = "if"
        match(param: "if")
        cstIndent += 1
        cst.append(String(repeatElement("•", count: cstIndent))  + "<Boolean Expression>")
        ParseBoolean()
        
        ParseBlock()
        
    }
    
    func ParseBoolean() {
        
        if parseList.first! == "(" {
            
            finalList.append("Expecting left paren")
            currentTerm = "left paren"
            match(param: "(")
            ParseExpr()
            
            if parseList.first! == "==" {
                finalList.append("Expecting boolop")
                currentTerm = "boolop"
                match(param: "==")
                ParseExpr()
                
            } else if parseList.first! == "!=" {
                finalList.append("Expecting boolop")
                currentTerm = "boolop"
                match(param: "!=")
                ParseExpr()
                
            }
            finalList.append("Expecting right paren")
            currentTerm = "right paren"
            match(param: ")")
            
        } else if parseList.first! == "true" {
            
            finalList.append("Expecting boolVal")
            currentTerm = "boolVal"
            match(param: "true")
            
        } else if parseList.first! == "false" {
            
            finalList.append("Expecting boolVal")
            currentTerm = "boolVal"
            match(param: "false")
        
        } else {
        
            match(param: "Boolean Expression")
        
        }
    
    }
    
    func ParseWhile() {
    
        
        finalList.append("- Got while statement!")
        parseList.removeFirst()
        ParseBoolean()
        ParseBlock()
    
    }
    
    func ParseVarDec() {
    
        finalList.append("- Got type: \(String(describing: parseList.first!))!")
        
        if String(describing: parseList.first!) == "int" {
        
            cstIndent += 1
            cst.append(String(repeatElement("•", count: cstIndent))  + "[ int ]")
        
        } else if String(describing: parseList.first!) == "string" {
            
            cstIndent += 1
            cst.append(String(repeatElement("•", count: cstIndent))  + "[ string ]")
            
        } else if String(describing: parseList.first!) == "boolean" {
            
            cstIndent += 1
            cst.append(String(repeatElement("•", count: cstIndent))  + "[ boolean ]")
            
        }
        
        parseList.removeFirst()
        ParseId()
    
    }
    
    
    func ParseId() {
    
        finalList.append("Expecting Id")
        
        if acceptedChars.contains(String(describing: parseList.first!)) {
            
            cst.append(String(repeatElement("•", count: cstIndent))  + "[ \(String(describing: parseList.first!)) ]")
            finalList.append("- Got Id: \(String(describing: parseList.first!))!")
            parseList.removeFirst()
            
        } else {
        
            currentTerm = "Id"
            match(param: "Id")
        
        }
    
    }
    
    func ParseAssignment() {
        
        finalList.append("- Got Id: \(String(describing: parseList.first!))!")
        cst.append(String(repeatElement("•", count: cstIndent))  + "[ \(String(describing: parseList.first!)) ]")
        parseList.removeFirst()
        finalList.append("Expecting Equals")
        currentTerm = "Equals"
        match(param: "=")
        ParseExpr()
    
    }
    
    func ParsePrint() {
    
        finalList.append("Expecting Print Statement")
        currentTerm = "print"
        match(param: "print")
        finalList.append("Expecting Left Paren")
        currentTerm = "left paren"
        match(param: "(")
        ParseExpr()
        
        if parseList.isEmpty == false {
            
            currentTerm = "right paren"
            finalList.append("Expecting Right Paren")
            match(param: ")")
            
        }

    }
    
    
    func ParseExpr() {
        
        cst.append(String(repeatElement("•", count: cstIndent))  + "< Expression >")
        cstIndent += 1
        
        if parseList.isEmpty == false {
        
            if acceptedNums.contains(String(describing: parseList.first!)) {
                
                ParseIntExpr()
                
            } else if acceptedChars.contains(String(describing: parseList.first!)) {
                
                ParseId()
                
            }  else if parseList.first! == "false" || parseList.first! == "true" {
                
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
        
        
        }
        
    }
    
    
    func match(param: Any) {
        
        print(param)
        
        
        if String(describing: param) == parseList.first! {
        
    
            if String(describing: param) == "}" {
               
                print(braceCounter)
                cst.append(String(repeatElement("•", count: braceCounter))  + "[ " + String(describing: param) + " ]")
                
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
                    cst.append(String(repeatElement("•", count: cstIndent))  + "[ " + String(describing: param) + " ]")
                    
                
                } else {
                    
                    print("now")
                    cst.append(String(repeatElement("•", count: cstIndent))  + "[ " + String(describing: param) + " ]")
                    
                }
            }
            
            finalList.append("- Got \(currentTerm)!")
            parseList.removeFirst()
            
            if currentTerm == "EOP" {
                
                finalList.append("Program \(parseCount) completed successfully.\n")
                parseCount += 1
                
            }
            
        } else {
            
            
            finalList.append("\nError - Expecting \(currentTerm).  Instead got \(String(describing: parseList.first!))")
            parseList.removeAll()
            cst.removeAll()
            
        }
    }

}
