//
//  CST.swift
//  Design Compiler
//
//  Created by Ryan Neumann on 3/6/17.
//  Copyright © 2017 RyanNeumann. All rights reserved.
//

import Foundation

var parseFinal = [Any]()
var parseList = cleanList
var currentTerm = String()
var cst = [Any]()
var cstIndent = 0
var braceCounter = 0

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
        cst.append("<Program>")
        ParseBlock()
        
        if parseList.isEmpty == false {
            //Skip check if list is empty
            cstIndent -= 1
            cst.append("-[$]")
            currentTerm = "EOP"
            parseFinal.append("Expecting EOP")
            match(param: "$")
            parseFinal.insert("Parsing completed successfully.\n", at: 0)
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
        cst.append(String(repeatElement("-", count: cstIndent))  + "<Block>")
        parseFinal.append("Expecting a left brace")
        currentTerm = "left brace"
        match(param: "{")
        
        cst.append(String(repeatElement("-", count: cstIndent))  + "<Statement List>")
        ParseStatementList()
        
        if parseList.isEmpty == false {
            
            parseFinal.append("Expecting a right brace")
            currentTerm = "right brace"
            print("Here")
            match(param: "}")

        }
    }
    
    func ParseStatementList() {
        
        if parseList.isEmpty == false {
            
            if parseList.first! == "}" || parseList.first! == "" || parseList.first! == "$" || parseList.first! == "\"" || parseList.first! == "'"{
                
                
                
            } else {
                
                
                    cstIndent += 1
                    cst.append(String(repeatElement("-", count: cstIndent))  + "<Statement>")
                    ParseStatement()
                
                print(currentTerm)
                if currentTerm != "right brace" {
                    
                    cstIndent += 1
                    cst.append(String(repeatElement("-", count: cstIndent))  + "<Statement List>")
                    
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
                cst.append(String(repeatElement("-", count: cstIndent))  + "<PRINT>")
                ParsePrint()
                
            } else if parseList.first! == "int" || parseList.first! == "string" || parseList.first! == "boolean" {
                
                cstIndent += 1
                cst.append(String(repeatElement("-", count: cstIndent))  + "<VARDEC>")
                parseFinal.append("Expecting type")
                ParseVarDec()
                
            } else if parseList.first! == "while" {
                
                cstIndent += 1
                cst.append(String(repeatElement("-", count: cstIndent))  + "<WHILE>")
                parseFinal.append("Expecting while statement")
                ParseWhile()
                
            } else if parseList.first! == "if" {
                
                cstIndent += 1
                cst.append(String(repeatElement("-", count: cstIndent))  + "<IF>")
                parseFinal.append("Expecting if statement")
                ParseIf()
                
            } else if acceptedChars.contains(String(describing: parseList.first!)) {
                
                cstIndent += 1
                cst.append(String(repeatElement("-", count: cstIndent))  + "<ASSIGNMENT>")
                parseFinal.append("Expecting Id")
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
        cst.append(String(repeatElement("-", count: cstIndent))  + "<BOOLEAN>")
        ParseBoolean()
        
        ParseBlock()
        
    }
    
    func ParseBoolean() {
        
        if parseList.first! == "(" {
            
            parseFinal.append("Expecting left paren")
            currentTerm = "left paren"
            match(param: "(")
            ParseExpr()
            
            if parseList.first! == "==" {
                parseFinal.append("Expecting boolop")
                currentTerm = "boolop"
                match(param: "==")
                ParseExpr()
                
            } else if parseList.first! == "!=" {
                parseFinal.append("Expecting boolop")
                currentTerm = "boolop"
                match(param: "!=")
                ParseExpr()
                
            }
            parseFinal.append("Expecting right paren")
            currentTerm = "right paren"
            match(param: ")")
            
        } else if parseList.first! == "true" {
            
            parseFinal.append("Expecting boolVal")
            currentTerm = "boolVal"
            match(param: "true")
            
        } else if parseList.first! == "false" {
            
            parseFinal.append("Expecting boolVal")
            currentTerm = "boolVal"
            match(param: "false")
        
        } else {
        
            match(param: "Boolean Expression")
        
        }
    
    }
    
    func ParseWhile() {
    
        
        parseFinal.append("- Got while statement!")
        parseList.removeFirst()
        ParseBoolean()
        ParseBlock()
    
    }
    
    func ParseVarDec() {
    
        parseFinal.append("- Got type: \(String(describing: parseList.first!))!")
        parseList.removeFirst()
        ParseId()
    
    }
    
    
    func ParseId() {
    
        parseFinal.append("Expecting Id")
        
        if acceptedChars.contains(String(describing: parseList.first!)) {
            
            parseFinal.append("- Got Id: \(String(describing: parseList.first!))!")
            parseList.removeFirst()
            
        } else {
        
            currentTerm = "Id"
            match(param: "Id")
        
        }
    
    }
    
    func ParseAssignment() {
        
        parseFinal.append("- Got Id: \(String(describing: parseList.first!))!")
        parseList.removeFirst()
        parseFinal.append("Expecting Equals")
        currentTerm = "Equals"
        match(param: "=")
        ParseExpr()
    
    }
    
    func ParsePrint() {
    
        parseFinal.append("Expecting Print Statement")
        currentTerm = "print"
        match(param: "print")
        parseFinal.append("Expecting Left Paren")
        currentTerm = "left paren"
        match(param: "(")
        ParseExpr()
        
        if parseList.isEmpty == false {
            
            currentTerm = "right paren"
            parseFinal.append("Expecting Right Paren")
            match(param: ")")
            
        }

    }
    
    
    func ParseExpr() {
        
        if parseList.isEmpty == false {
        
            if acceptedNums.contains(String(describing: parseList.first!)) {
                
                ParseIntExpr()
                
            } else if acceptedChars.contains(String(describing: parseList.first!)) {
                
                ParseId()
                
            }  else if parseList.first! == "false" || parseList.first! == "true" {
                
                ParseBoolean()
                
            }  else if parseList.first! == "while" {
                
                parseFinal.append("Expecting while statement")
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
        
        if parseList[1] == "+" {
            
            parseFinal.append("Expecting digit")
            parseFinal.append("- Got digit: \(String(describing: parseList.first!))!")
            parseList.removeFirst()
            parseFinal.append("Expecting IntOp")
            currentTerm = "IntOp"
            match(param: "+")
            ParseExpr()
            
        } else {
        
            parseFinal.append("Expecting digit")
            parseFinal.append("- Got digit: \(String(describing: parseList.first!))!")
            parseList.removeFirst()
        
        }
        
        
    }
    
    func ParseStringExpr() {
        
        parseFinal.append("Expecting open_quote")
        currentTerm = "open_quote"
        match(param: "\"")
        ParseCharList()
        parseFinal.append("Expecting close_quote")
        currentTerm = "close_quote"
        match(param: "\"")

    }
    
    func ParseCharList() {
    
        if acceptedChars.contains(String(describing: parseList.first!)) {
        
            parseFinal.append("Expecting char")
            parseFinal.append("- Got char: \(String(describing: parseList.first!))!")
            parseList.removeFirst()
            ParseCharList()
        
        } else if parseList.first! == " " {
        
            parseFinal.append("Expecting potential white space")
            parseFinal.append("- Got white space!")
            parseList.removeFirst()
            ParseCharList()
            
        } else {
        
        
        }
        
    }
    
    
    func match(param: Any) {
        
        print(param)
        
        
        if String(describing: param) == parseList.first! {
        
    
            if String(describing: param) == "}" {
                if braceCounter < 1 {
                
                    braceCounter += 1
                
                } else {
                    
                    cstIndent -= 3
                    
                }
            }
            
            if String(describing: param) != "}"  && String(describing: param) != "$" {
            
                cstIndent += 1
            
            } else if String(describing: param) == "$" {
            
                    cstIndent -= 1
            
            }

            
            if String(describing: param) != "$" && String(describing: param) != "Statement List" {
                
                cst.append(String(repeatElement("-", count: cstIndent))  + "[" + String(describing: param) + "]")
                
            }
            
            parseFinal.append("- Got \(currentTerm)!")
            parseList.removeFirst()
            
        } else {
            
            
            parseFinal.append("\nError - Expecting \(currentTerm).  Instead got \(String(describing: parseList.first!))")
            parseList.removeAll()
            
        }
    }

}
