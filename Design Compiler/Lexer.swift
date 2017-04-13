//
//  Lexer.swift
//  Design Compiler
//
//  Created by Ryan Neumann on 2/12/17.
//  Copyright © 2017 RyanNeumann. All rights reserved.
//
import Foundation

var errorCount = 0
var currentLine = 1
var programNum = 0
var inputText = [Character]()
var finalList = [String]()
var textEntered: String = ""
let unacceptedList = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "@", "%", "&", "*", "_", "-", "#", "~", "`", "^", "|", "."]
let acceptedChars = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
let acceptedNums = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
let boolOp = ["==", "!="]
let boolVal = ["true", "false"]
let intOp = "+"
var cleanList = [String]()

extension ViewController {
    
    func checkNext() {
        
        let y = inputText.first
        
        if y == nil {
            //If y is empty, print the final list of tokens
            printFinal()
            
        } else {
            
            if finalList.isEmpty {
                //Processing Program 1
                finalList.append("Lexing program 0...")
                checkNext()
                
            } else {
                
                if y == "{" {
                    
                    cleanList.append("{")
                    scopeTracker += 1
                    finalList.append("\(currentLine).  {  --> [LBRACE]")
                    inputText.removeFirst()
                    checkNext()
                    
                } else if unacceptedList.contains(String(describing: y!)){
                    //CHECK FOR ERRORS
                    finalList.append("\(currentLine). ERROR: Unrecognized Token: \(y!) on line \(currentLine)")
                    inputText.removeFirst()
                    errorCount += 1
                    checkNext()
                    
                } else if y == "i" {
                    //NO ERRORS... CHECKING NEXT CHARACTER
                    if inputText[1] == "n" && inputText[2] == "t" {
                        //CHECKING FOR INT
                        finalList.append("\(currentLine).  int  --> [INT]")
                        cleanList.append("int")
                        lineNums = lineNums.adding(currentLine) as NSArray
                        symbolScope = symbolScope.adding(scopeTracker) as NSArray
                        inputText.removeFirst(3)
                        checkId()
                        
                    } else if inputText[1] == "f" {
                        //CHECKING FOR IF
                        finalList.append("\(currentLine).  if  --> [TYPE]")
                        cleanList.append("if")
                        inputText.removeFirst(2)
                        checkNext()
                        
                    } else if ((inputText[1] == "=") ||  (inputText[1] == "!")) {
                        //CHECKING FOR ASSIGNMENT
                        finalList.append("\(currentLine).  i  --> [ID]")
                        scopeChecker("i")
                        cleanList.append("i")
                        inputText.removeFirst()
                        checkNext()
                        
                    } else {
                        
                        finalList.append("\(currentLine).  i  --> [CHAR]")
                        cleanList.append("i")
                        inputText.removeFirst()
                        checkNext()
                        
                    }
                    
                } else if y == "\t" {
                    //REMOVING TABS
                    inputText.removeFirst()
                    checkNext()
                    
                } else if y == "t" {
                    
                    if inputText[1] == "r" && inputText[2] == "u" && inputText[3] == "e" {
                        //CHECKING FOR "TRUE"
                        finalList.append("\(currentLine).  true  --> [TRUE]")
                        cleanList.append("true")
                        inputText.removeFirst(4)
                        checkNext()
                        
                    } else if inputText[1] == "=" || inputText[1] == "!" {
                        //CHECKING FOR ASSIGNMENT
                        scopeChecker("t")
                        finalList.append("\(currentLine).  t  --> [ID]")
                        cleanList.append("t")
                        inputText.removeFirst()
                        checkNext()
                        
                    } else {
                        
                        finalList.append("\(currentLine).  t  --> [CHAR]")
                        cleanList.append("t")
                        inputText.removeFirst()
                        checkNext()
                        
                    }
                    
                } else if y == "f" {
                    
                    if inputText[1] == "a" && inputText[2] == "l" && inputText[3] == "s" && inputText[4] == "e" {
                        //CHECKING FOR FALSE
                        finalList.append("\(currentLine).  false  --> [FALSE]")
                        cleanList.append("false")
                        inputText.removeFirst(5)
                        checkNext()
                        
                    } else if inputText[1] == "=" || inputText[1] == "!" {
                        //CHECKING FOR ASSIGNMENT
                        cleanList.append("f")
                        scopeChecker("f")
                        finalList.append("\(currentLine).  f  --> [ID]")
                        inputText.removeFirst()
                        checkNext()
                        
                    } else {
                        
                        cleanList.append("f")
                        finalList.append("\(currentLine).  f  --> [CHAR]")
                        inputText.removeFirst()
                        checkNext()
                        
                    }
                    
                } else if y == "w" {
                    
                    if inputText[1] == "h" && inputText[2] == "i" && inputText[3] == "l" && inputText[4] == "e" {
                        //CHECKING FOR WHILE
                        finalList.append("\(currentLine).  while  --> [WHILE]")
                        inputText.removeFirst(5)
                        cleanList.append("while")
                        checkNext()
                        
                    } else if inputText[1] == "=" || inputText[1] == "!" {
                        //CHECKING FOR ASSIGNMENT
                        scopeChecker("w")
                        finalList.append("\(currentLine).  w  --> [ID]")
                        cleanList.append("w")
                        inputText.removeFirst()
                        checkNext()
                        
                    } else {
                        
                        finalList.append("\(currentLine).  w  --> [CHAR]")
                        cleanList.append("w")
                        inputText.removeFirst()
                        checkNext()
                        
                    }
                    
                } else if y == "p" {
                    
                    if inputText[1] == "r" && inputText[2] == "i" && inputText[3] == "n" && inputText[4] == "t" {
                        //CHECKING FOR PRINT
                        finalList.append("\(currentLine).  print  --> [PRINT]")
                        cleanList.append("print")
                        inputText.removeFirst(5)
                        checkNext()
                        
                    } else if inputText[1] == "=" || inputText[1] == "!" {
                        //CHECKING FOR ASSIGNMENT
                        finalList.append("\(currentLine).  p  --> [ID]")
                        scopeChecker("p")
                        cleanList.append("p")
                        inputText.removeFirst()
                        checkNext()
                        
                    } else {
                        
                        finalList.append("\(currentLine).  p  --> [CHAR]")
                        cleanList.append("p")
                        inputText.removeFirst()
                        checkNext()
                        
                    }
                    
                } else if y == "b" {
                    
                    if inputText[1] == "o" && inputText[2] == "o" && inputText[3] == "l" && inputText[4] == "e" && inputText[5] == "a" && inputText[6] == "n" {
                        //CHECKING FOR BOOLEAN
                        finalList.append("\(currentLine).  boolean  --> [BOOLEAN]")
                        cleanList.append("boolean")
                        symbolScope = symbolScope.adding(scopeTracker) as NSArray
                        lineNums = lineNums.adding(currentLine) as NSArray
                        inputText.removeFirst(7)
                        checkId()
                        
                    } else if inputText[1] == "=" || inputText[1] == "!" {
                        //CHECKING FOR ASSIGNMENT
                        finalList.append("\(currentLine).  b  --> [ID]")
                        scopeChecker("b")
                        cleanList.append("b")
                        inputText.removeFirst()
                        checkNext()
                        
                    } else {
                        
                        finalList.append("\(currentLine).  b  --> [CHAR]")
                        cleanList.append("b")
                        inputText.removeFirst()
                        checkNext()
                        
                    }
                    
                } else if y == "s" {
                    
                    if inputText[1] == "t" && inputText[2] == "r" && inputText[3] == "i" && inputText[4] == "n" && inputText[5] == "g" {
                        //CHECKING FOR STRING
                        cleanList.append("string")
                        lineNums = lineNums.adding(currentLine) as NSArray
                        symbolScope = symbolScope.adding(scopeTracker) as NSArray
                        finalList.append("\(currentLine).  string  --> [STRING]")
                        inputText.removeFirst(6)
                        checkId()
                        
                    } else if inputText[1] == "=" || inputText[1] == "!" {
                        //CHECKING FOR ASSIGNMENT
                        cleanList.append("s")
                        finalList.append("\(currentLine).  s  --> [ID]")
                        scopeChecker("s")
                        inputText.removeFirst()
                        checkNext()
                        
                    } else {
                        
                        cleanList.append("s")
                        finalList.append("\(currentLine).  s  --> [CHAR]")
                        inputText.removeFirst()
                        checkNext()
                        
                    }
                    
                } else if y == "}" {
                    
                    scopeTracker -= 1
                    cleanList.append("}")
                    finalList.append("\(currentLine).  }  --> [RBRACE]")
                    inputText.removeFirst()
                    checkNext()
                    
                } else if y == "(" {
                    
                    if acceptedChars.contains(String(describing: inputText[1])) && inputText[2] == ")" {
                        //CHECKING IF PARENTHESES CONTAIN IDENTIFIER
                        finalList.append("\(currentLine).  (  --> [LPAREN]")
                        cleanList.append("(")
                        cleanList.append(String(describing: inputText[1]))
                        finalList.append("\(currentLine).  \(String(describing: inputText[1])) --> [ID]")
                        scopeChecker(String(describing: inputText[1]))
                        
                        cleanList.append(")")
                        finalList.append("\(currentLine).  )  --> [RPAREN]")
                        inputText.removeFirst(3)
                        checkNext()
                        
                    } else if (acceptedChars.contains(String(describing: inputText[1])) && (inputText[2] == "=")) && inputText[3] == "=" {
                        
                        cleanList.append("(")
                        finalList.append("\(currentLine).  (  --> [LPAREN]")
                        cleanList.append(String(describing: inputText[1]))
                        finalList.append("\(currentLine).  \(String(describing: inputText[1])) --> [ID]")
                        scopeChecker(String(describing: inputText[1]))
                        cleanList.append("==")
                        finalList.append("\(currentLine).  ==  --> [BOOLOP]")
                        inputText.removeFirst(4)
                        checkNext()
                        
                    } else if (acceptedChars.contains(String(describing: inputText[1])) && (inputText[2] == "!")) && inputText[3] == "=" {
                        
                        cleanList.append("(")
                        cleanList.append(String(describing: inputText[1]))
                        cleanList.append("!=")
                        finalList.append("\(currentLine).  (  --> [LPAREN]")
                        finalList.append("\(currentLine).  \(String(describing: inputText[1])) --> [ID]")
                        scopeChecker(String(describing: inputText[1]))
                        finalList.append("\(currentLine).  !=  --> [BOOLOP]")
                        inputText.removeFirst(4)
                        checkNext()
                        
                    } else {
                        
                        cleanList.append("(")
                        finalList.append("\(currentLine).  (  --> [LPAREN]")
                        inputText.removeFirst()
                        checkNext()
                        
                    }
                    
                } else if y == ")" {
                    
                    cleanList.append(")")
                    finalList.append("\(currentLine).  )  --> [RPAREN]")
                    inputText.removeFirst()
                    checkNext()
                    
                } else if y == "$" {
                    //CHECKS FOR END-OF-PROGRAM AND CREATES NEW ONE
                    cleanList.append("$")
                    finalList.append("\(currentLine).  $  --> [EOP]\n")
                    inputText.removeFirst()
                    newProgram()
                    
                } else if y == "!" {
                    
                    if inputText[1] == "=" {
                        //CHECKING FOR BOOLOP
                        finalList.append("\(currentLine).  !=  --> [BOOLOP]")
                        cleanList.append("!=")
                        inputText.removeFirst(2)
                        checkNext()
                        
                    } else {
                        
                        finalList.append("\(currentLine).  ERROR: Unrecognized Token: \(inputText.first!) on line \(currentLine)")
                        inputText.removeFirst()
                        errorCount += 1
                        checkNext()
                        
                    }
                    
                } else if y == "\n" {
                    
                    currentLine += 1
                    inputText.removeFirst()
                    checkNext()
                    
                } else if y == "=" {
                    
                    if inputText[1] == "=" {
                        //CHECKING FOR BOOLOP
                        finalList.append("\(currentLine).  ==  --> [BOOLOP]")
                        cleanList.append("==")
                        inputText.removeFirst(2)
                        checkNext()
                        
                    } else if (acceptedChars.contains(String(describing: inputText[1])) && String(describing: inputText[1]) != ("t") && String(describing: inputText[1]) != ("f"))  {
                        
                        cleanList.append("=")
                        cleanList.append(String(describing: inputText[1]))
                        finalList.append("\(currentLine).  =  --> [SINGLE_EQUALS]")
                        finalList.append("\(currentLine).  \(inputText[1])  --> [ID]")
                        scopeChecker(String(describing: inputText[1]))
                        inputText.removeFirst(2)
                        checkNext()
                        
                    } else {
                        
                        cleanList.append("=")
                        finalList.append("\(currentLine).  =  --> [SINGLE_EQUALS]")
                        inputText.removeFirst()
                        checkNext()
                        
                    }
                    
                } else if intOp.contains(String(describing: y!)) {
                    
                    if acceptedChars.contains(String(describing: inputText[1])) {
                        
                        cleanList.append("+")
                        finalList.append("\(currentLine).  +  --> [INTOP]")
                        cleanList.append(String(describing: inputText[1]))
                        finalList.append("\(currentLine).  \(String(describing: inputText[1]))  --> [ID]")
                        scopeChecker(String(describing: inputText[1]))
                        inputText.removeFirst(2)
                        checkNext()
                        
                    } else {
                        
                        cleanList.append("+")
                        finalList.append("\(currentLine).  +  --> [INTOP]")
                        inputText.removeFirst()
                        checkNext()
                        
                    }
                    
                } else if acceptedNums.contains(String(describing: y!)) {
                    
                    cleanList.append(String(describing: y!))
                    finalList.append("\(currentLine).  \(y!)  --> [DIGIT]")
                    inputText.removeFirst()
                    checkNext()
                    
                } else if acceptedChars.contains(String(describing: y!)) {
                    
                    if inputText[1] == "=" {
                    
                        cleanList.append(String(describing: y!))
                        finalList.append("\(currentLine).  \(y!)  --> [ID]")
                        scopeChecker(String(describing: y!))
                        inputText.removeFirst()
                        checkNext()
                        
                    } else {
                        
                        cleanList.append(String(describing: y!))
                        finalList.append("\(currentLine).  \(y!)  --> [CHAR]")
                        inputText.removeFirst()
                        checkNext()
                        
                    }
                    
                } else if (y == "\"" || y == "“") {
                    
                    cleanList.append("\"")
                    finalList.append("\(currentLine).  \"  --> [OPEN_DOUBLE_QUOTE]")
                    inputText.removeFirst()
                    startCharList()
                    
                } else if y == " " {
                    
                    inputText.removeFirst()
                    checkNext()
                    
                } else {
                    
                    printFinal()
                    
                }
                
            }
            
        }
        
    }
    
    func startCharList() {
        
        if inputText.first != "\"" {
            
            let y = inputText.first!
            
            if acceptedNums.contains(String(describing:y)) {
                
                finalList.append("\(currentLine).  ERROR: Unrecognized Token: \(inputText.first!) on line \(currentLine)")
                inputText.removeFirst()
                errorCount += 1
                startCharList()
                
            } else if acceptedChars.contains(String(describing:y)) {
                
                cleanList.append(String(describing: y))
                finalList.append("\(currentLine).  \(y)  --> [Char]")
                inputText.removeFirst()
                startCharList()
                
            } else if y == " " {
                
                cleanList.append(String(describing: y))
                finalList.append("\(currentLine).  \(y)  --> [WHITE_SPACE]")
                inputText.removeFirst()
                startCharList()
                
                
            } else if y == "$" || y == "\n" || y == "\t" {
                
                finalList.append("\(currentLine).  ERROR: Unrecognized Token: \(inputText.first!) on line \(currentLine)")
                inputText.removeFirst()
                errorCount += 1
                startCharList()
                
            } else if y == "}" {
                
                cleanList.append("}")
                finalList.append("\(currentLine).  }  --> [RBRACE]")
                inputText.removeFirst()
                warningLabel.stringValue = "Please don't forget to close quote"
                checkNext()
                
            } else if y == ")" {
            
                cleanList.append(")")
                finalList.append("\(currentLine).  \"  --> [CLOSE_DOUBLE_QUOTES]")
                finalList.append("\(currentLine).  )  --> [RPAREN]")
                inputText.removeFirst()
                warningLabel.stringValue = "Please don't forget to close quote"
                checkNext()
            
            } else {
                
                checkNext()
                
            }
            
        } else {
            
            cleanList.append("\"")
            finalList.append("\(currentLine).  \"  --> [CLOSE_DOUBLE_QUOTES]")
            inputText.removeFirst()
            checkNext()
            
        }
        
    }
    
    func checkId() {
        //Checks to see if character is part of keyword
        if acceptedNums.contains(String(describing: inputText.first!)) || acceptedChars.contains(String(describing: inputText.first!)) {
            
            let y = inputText.first!
            cleanList.append(String(describing: y))
            finalList.append("\(currentLine).  \(y)  --> [ID]")
            symbolName.append(String(describing: y))
            inputText.removeFirst()
            checkNext()
            
        } else {
            
            finalList.append("\(currentLine).  ERROR: Unrecognized Token: \(inputText.first!) on line \(currentLine)")
            inputText.removeFirst()
            errorCount += 1
            checkNext()
            
        }
        
    }
    
    func newProgram() {

        if errorCount == 0 {
            
            if inputText.isEmpty == false{
                
                finalList.append("Lex completed program \(programNum) successfully.\n")
                astList = []
                currentBrace = 0
                braceCounter = []
                statementEnding = 0
                cstIndent = 0
                ParseProgram()
                
                if parseError == 0 {
                    
                    astFinal.string?.append("**Program \(programNum) completed successfully.**\n")
                    astFinal.string?.append("\n")
                    finalList.append("Program \(programNum) Semantic Analysis...")
                    symbolList.string?.append("Program \(programNum) Symbol Table\n")
                    produceSymbolTable()
                    typeErrors = []
                    errorArray = []
                    symbolScope = []
                    symbolType = []
                    symbolTable = []
                    errorArray = []
                    symbolName = []
                    scopeErrors = 0
                    lineNums = []
                    symbolList.string?.append("\n")
                    
                } else {
                
                    
                    parseError = 0
                
                }
                
                errorCounter = 0
                programNum += 1
                
                if inputText.contains("{") {
                
                    finalList.append("Lexing program \(programNum)...")
                
                }
                
                checkNext()
    
            } else {
                
                astList = []
                finalList.append("Lex completed program \(programNum) successfully.\n")
                ParseProgram()
                if parseError == 0 {
                
                    astFinal.string?.append("**Program \(programNum) completed successfully.**\n")
                    astFinal.string?.append("\n")
                    finalList.insert("Lex completed successfully!", at: 0)
                    finalList.append("Program \(programNum) Semantic Analysis...")
                    symbolList.string?.append("Program \(programNum) Symbol Table\n")
                    produceSymbolTable()
                    symbolScope = []
                    symbolType = []
                    errorArray = []
                    symbolName = []
                    lineNums = []
                    typeErrors = []
                    
                } else {
                
                    parseError = 0
                
                }
                printFinal()
                
            }
            
        } else {
            
            if inputText.isEmpty == false {
                
                finalList.append("Lex completed with \(errorCount) error(s).")
                errorCount = 0
                checkNext()
                
            } else {
                
                finalList.append("Lex completed with \(errorCount) error(s).")
                printFinal()
                
            }
            
        }
        
    }
    
    func printFinal() {
        
        tokenList.string = ""
        inputText = []
        
        for element in finalList {
            
            if element.contains("$  --> [EOP]") {
            
                tokenList.string?.append(element)
            
            } else {
            
                tokenList.string?.append(element + "\n")
            
            }
            
        }
        
    }
    
}
