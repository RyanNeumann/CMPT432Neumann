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
var astList: NSArray = []
var astIndent = 0
var quoteText = ""
var parseError = 0
var typeBool = false

extension ViewController {
    
    func ParseProgram() {
        //Clears any settings from previous run
        parseList = cleanList
        cleanList.removeAll()
        parsedList.string?.removeAll()
        parsedList.string = ""
        parseFinal.removeAll()
        braceCounter = []
        //Initializing Block
        cstIndent = 0
        cst.append("< Program >")
        finalList.append("Parsing program \(parseCount)...")
        ParseBlock()
        
        if parseList.isEmpty == false {
            //Skip check if list is empty
            cstIndent -= 1
            cst.append("•[$] ")
            cst.append("**Program \(programNum) completed successfully.**\n")
            currentTerm = "EOP"
            finalList.append("Expecting EOP")
            match(param: "$")
            print(astList)
            
            if finalList.contains("Parsing completed successfully.\n") == false {
            
                finalList.insert("Parsing completed successfully.\n", at: 0)
                
            }
            
        }
        
        parsedList.string = ""
        
        for element in cst {
            
            parsedList.string?.append(String(describing: element) + "\n")
        
        }
        
        tokenList.string?.append("\n")
        
        for element in parseFinal {
            //Print final string in Parser box.
            tokenList.string?.append(String(describing: element) + "\n")
            
        }
        
        for element in astList {
        
            astFinal.string?.append(String(describing: element) + "\n")
        
        }
    
    }
    
    func ParseBlock() {
        
        cstIndent += 1
        cst.append(String(repeatElement("•", count: cstIndent))  + "< Block >")
        astList = astList.adding(String(repeatElement("-", count: astIndent)) + "< Block >") as NSArray
        astIndent += 1
        
        if parseList.first! == "{" {
            
            finalList.append("Expecting a left brace")
            currentTerm = "left brace"
            match(param: "{")
            
        }
        
        ParseStatementList()
        
        if parseList.isEmpty == false && parseList.first! != "$" {
            
            finalList.append("Expecting a right brace")
            currentTerm = "right brace"
            match(param: "}")
            cstIndent -= 2
            astIndent -= 1
            
        }
        
    }
    
    func ParseStatementList() {
        
        if cstIndent != 0 {
         
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
        
        astList = astList.adding(String(repeatElement("-", count: astIndent)) + "< If Statement >") as NSArray
        currentTerm = "if"
        match(param: "if")
        ParseBoolean()
        ParseBlock()
        
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
                
                astList = astList.adding(String(repeatElement("-", count: astIndent)) + "[ == ]") as NSArray
                finalList.append("Expecting boolop")
                currentTerm = "boolop"
                match(param: "==")
                ParseExpr()
                
            } else if parseList.first! == "!=" {
                
                astList = astList.adding(String(repeatElement("-", count: astIndent)) + "[ != ]") as NSArray
                finalList.append("Expecting boolop")
                currentTerm = "boolop"
                match(param: "!=")
                ParseExpr()
                
            } else if parseList.first! == "{" {
            
                ParseBlock()
            
            }
            
        } else if parseList.first! == "true" {
            
            astList = astList.adding(String(repeatElement("-", count: astIndent)) + "[ true ]") as NSArray
            finalList.append("Expecting boolVal")
            currentTerm = "boolVal"
            match(param: "true")
            
        } else if parseList.first! == "false" {
            
            astList = astList.adding(String(repeatElement("-", count: astIndent)) + "[ false ]") as NSArray
            finalList.append("Expecting boolVal")
            currentTerm = "boolVal"
            match(param: "false")
        
        } else {
        
            match(param: "Boolean Expression")
        
        }
    
    }
    
    func ParseWhile() {
        
        astList = astList.adding(String(repeatElement("-", count: astIndent)) + "< While Statement >") as NSArray
        finalList.append("- Got while statement!")
        parseList.removeFirst()
        ParseBoolean()
        ParseBlock()
    
    }
    
    func ParseVarDec() {
    
        astList = astList.adding(String(repeatElement("-", count: astIndent)) + "< Variable Declaration >") as NSArray
        astIndent += 1
        finalList.append("- Got type: \(String(describing: parseList.first!))!")
        
        if String(describing: parseList.first!) == "int" {
        
            cstIndent += 1
            cst.append(String(repeatElement("•", count: cstIndent))  + "[ int ]")
            symbolType = symbolType.adding("int") as NSArray
            astList = astList.adding(String(repeatElement("-", count: astIndent))  + "[ int ]") as NSArray
            typeBool = true
            
        } else if String(describing: parseList.first!) == "string" {
            
            cstIndent += 1
            cst.append(String(repeatElement("•", count: cstIndent))  + "[ string ]")
            symbolType = symbolType.adding("string") as NSArray
            astList = astList.adding(String(repeatElement("-", count: astIndent))  + "[ string ]") as NSArray
            typeBool = true
            
        } else if String(describing: parseList.first!) == "boolean" {
            
            cstIndent += 1
            cst.append(String(repeatElement("•", count: cstIndent))  + "[ boolean ]")
            symbolType = symbolType.adding("bool") as NSArray
            astList = astList.adding(String(repeatElement("-", count: astIndent))  + "[ boolean ]") as NSArray
            typeBool = true
            
        }
        
        parseList.removeFirst()
        ParseId()
        astIndent -= 1
    
    }
    
    func ParseId() {
    
        if acceptedChars.contains(String(describing: parseList.first!)) {
            
            if typeBool == false {
                
                beforeBool = false
                typeChecker(String(describing: parseList.first!))
            
            } else {
            
                typeBool = false
            
            }
            cst.append(String(repeatElement("•", count: cstIndent))  + "[ \(String(describing: parseList.first!)) ]")
            astList = astList.adding(String(repeatElement("-", count: astIndent))  + "[ \(String(describing: parseList.first!)) ]") as NSArray
            finalList.append("- Got Id: \(String(describing: parseList.first!))!")
            parseList.removeFirst()
            
        } else {
        
            currentTerm = "Id"
            match(param: "Id")
        
        }
    
    }
    
    func ParseAssignment() {
        
        astList = astList.adding(String(repeatElement("-", count: astIndent)) + "< Assignment Statement >") as NSArray
        astIndent += 1
        astList = astList.adding(String(repeatElement("-", count: astIndent)) + "[ \(String(describing: parseList.first!)) ]") as NSArray
        finalList.append("- Got Id: \(String(describing: parseList.first!))!")
        cst.append(String(repeatElement("•", count: cstIndent))  + "[ \(String(describing: parseList.first!)) ]")
        beforeBool = true
        typeChecker(parseList.first!)
        parseList.removeFirst()
        finalList.append("Expecting Equals")
        currentTerm = "Equals"
        match(param: "=")
        
        if parseList.isEmpty == false {
            
            ParseExpr()
            astIndent -= 1
            
        }
        
    }
    
    func ParsePrint() {
    
        astList = astList.adding(String(repeatElement("-", count: astIndent)) + "< Print Statement >") as NSArray
        astIndent += 1
        finalList.append("Expecting Print Statement")
        currentTerm = "print"
        match(param: "print")
        finalList.append("Expecting Left Paren")
        currentTerm = "left paren"
        parenMatch = cstIndent
        match(param: "(")
        ParseExpr()
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
                
                ParseIntExpr()
                
            } else if acceptedChars.contains(String(describing: parseList.first!)) {
                
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
            
            astList = astList.adding(String(repeatElement("-", count: astIndent)) + "[ + ]") as NSArray
            finalList.append("Expecting digit")
            finalList.append("- Got digit: \(String(describing: parseList.first!))!")
            cst.append(String(repeatElement("•", count: cstIndent))  + "[ \(String(describing: parseList.first!)) ]")
            astList = astList.adding(String(repeatElement("-", count: astIndent))  + "[ \(String(describing: parseList.first!)) ]") as NSArray
            parseList.removeFirst()
            finalList.append("Expecting IntOp")
            currentTerm = "IntOp"
            match(param: "+")
            ParseExpr()
            
        } else {
        
            finalList.append("Expecting digit")
            cst.append(String(repeatElement("•", count: cstIndent))  + "[ \(String(describing: parseList.first!)) ]")
            astList = astList.adding(String(repeatElement("-", count: astIndent))  + "[ \(String(describing: parseList.first!)) ]") as NSArray
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
        
            astList = astList.adding(String(repeatElement("-", count: astIndent))  + "[ \(quoteText) ]") as NSArray
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
                    
                    finalList.append("Program \(parseCount) completed successfully.\n")
                    parseCount += 1
                    
                }
                
            } else {
                
                parseError += 1
                finalList.append("\nError - Expecting \(currentTerm).  Instead got \(String(describing: parseList.first!))\n")
                parsedList.string = ""
                parseList.removeAll()
                cst.removeAll()
                
            }
            
        }
    
    }
    
}
