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

extension ViewController {
    
    func ParseProgram() {
        
        parseList = cleanList
        cleanList.removeAll()
        parsedList.string?.removeAll()
        parseFinal.removeAll()

        ParseBlock()
        
        if parseList.isEmpty == false {
            currentTerm = "EOP"
            parseFinal.append("Expecting EOP")
            match(param: "$")
        }
        
        parsedList.string = ""
        var lineNumber = 0
        
        for element in parseFinal {
            
            parsedList.string?.append(String(describing: element) + "\n")
            lineNumber += 1
            
        }
    
    }

    func ParseBlock() {
        print("here")
        
        parseFinal.append("Expecting a left brace")
        currentTerm = "left brace"
        match(param: "{")
        ParseStatementList()
        
        if parseList.isEmpty == false {
            
            parseFinal.append("Expecting a right brace")
            currentTerm = "right brace"
            match(param: "}")

        }
    }
    
    func ParseStatementList() {
        
        if parseList.isEmpty == false {
            
            if parseList.first! == "}" || parseList.first! == "" || parseList.first! == "$" || parseList.first! == "\"" || parseList.first! == "'"{
                
                
                
            } else {
                
                ParseStatement()
                ParseStatementList()
                
            }
            
        }
        
    }

    func ParseStatement() {
        
        if parseList.isEmpty == false {
        
            print(parseList)
            if parseList.first! == "print" {
                
                ParsePrint()
                
            } else if parseList.first! == "int" || parseList.first! == "string" || parseList.first! == "boolean" {
                
                parseFinal.append("Expecting type")
                ParseVarDec()
                
            } else if parseList.first! == "while" {
                
                parseFinal.append("Expecting while statement")
                ParseWhile()
                
            } else if parseList.first! == "if" {
                
                parseFinal.append("Expecting if statement")
                ParseIf()
                
            } else if acceptedChars.contains(String(describing: parseList.first!)) {
                
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
        ParseBoolean()
        ParseBlock()
        
    }
    
    func ParseBoolean() {
        
        
        print(parseList.first!)
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
        currentTerm = "right paren"
        parseFinal.append("Expecting Right Paren")
        match(param: ")")

    }
    
    
    func ParseExpr() {
        
        if acceptedNums.contains(String(describing: parseList.first!)) {
        
            ParseIntExpr()
        
        } else if acceptedChars.contains(String(describing: parseList.first!)) {
            
            ParseId()
            
        }  else
        
        if parseList.first! == "false" || parseList.first! == "true" {
        
            ParseBoolean()
        
        }  else
        
        if parseList.first! == "while" {
            
            parseFinal.append("Expecting while statement")
            ParseWhile()
            
        }  else
        
        if parseList.first! == "\"" {
        
            ParseStringExpr()
        
        } else {
            
            currentTerm = "Expr"
            match(param: "Expr")
        
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
        
            parseFinal.append("- Got \(currentTerm)!")
            parseList.removeFirst()
            
        } else {
            
            parseFinal.append("\nError - Expecting \(currentTerm).  Instead got \(String(describing: parseList.first!))")
            parseList.removeAll()
            
        }
    }

}
