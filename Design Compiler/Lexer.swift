//
//  Lexer.swift
//  Design Compiler
//
//  Created by Ryan Neumann on 2/12/17.
//  Copyright © 2017 RyanNeumann. All rights reserved.
//
import Foundation

var errorCount = 0

var lineNumber = 0

var currentLine = 0

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
            //print(finalList)
            if finalList.isEmpty {
                //Processing Program 1
                
                finalList.append("Lexing program 0...")
                checkNext()
                
            } else {
                
                if unacceptedList.contains(String(describing: y!)){
                    
                    //CHECK FOR ERRORS
                    finalList.append("\(lineNumber). ERROR: Unrecognized Token: \(y!) on line \(currentLine)")
                    inputText.removeFirst()
                    errorCount += 1
                    lineNumber += 1
                    checkNext()
                    
                    
                } else if y == "i" {
                    //NO ERRORS... CHECKING NEXT CHARACTER
                    if inputText[1] == "n" && inputText[2] == "t" {
                        //CHECKING FOR INT
                        finalList.append("\(lineNumber).  int  --> [INT]")
                        cleanList.append("int")
                        inputText.removeFirst(3)
                        lineNumber += 1
                        checkId()
                        
                    } else if inputText[1] == "f" {
                        //CHECKING FOR IF
                        finalList.append("\(lineNumber).  if  --> [TYPE]")
                        cleanList.append("if")
                        inputText.removeFirst(2)
                        lineNumber += 1
                        checkNext()
                        
                    } else if ((inputText[1] == "=") ||  (inputText[1] == "!")) {
                        //CHECKING FOR ASSIGNMENT
                        finalList.append("\(lineNumber).  i  --> [ID]")
                        cleanList.append("i")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                        
                        
                        finalList.append("\(lineNumber).  i  --> [CHAR]")
                        cleanList.append("i")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    }
                    
                    
                } else if y == "\t" {
                    //REMOVING TABS
                    inputText.removeFirst()
                    checkNext()
                    
                } else if y == "t" {
                    
                    if inputText[1] == "r" && inputText[2] == "u" && inputText[3] == "e" {
                        //CHECKING FOR "TRUE"
                        finalList.append("\(lineNumber).  true  --> [TRUE]")
                        cleanList.append("true")
                        inputText.removeFirst(4)
                        lineNumber += 1
                        checkNext()
                        
                    } else if inputText[1] == "=" || inputText[1] == "!" {
                        //CHECKING FOR ASSIGNMENT
                        finalList.append("\(lineNumber).  t  --> [ID]")
                        cleanList.append("t")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                        
                        finalList.append("\(lineNumber).  t  --> [CHAR]")
                        cleanList.append("t")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    }
                    
                } else if y == "f" {
                    
                    if inputText[1] == "a" && inputText[2] == "l" && inputText[3] == "s" && inputText[4] == "e" {
                        //CHECKING FOR FALSE
                        finalList.append("\(lineNumber).  false  --> [FALSE]")
                        cleanList.append("false")
                        inputText.removeFirst(5)
                        lineNumber += 1
                        checkNext()
                        
                    } else if inputText[1] == "=" || inputText[1] == "!" {
                        //CHECKING FOR ASSIGNMENT
                        cleanList.append("f")
                        finalList.append("\(lineNumber).  f  --> [ID]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                        cleanList.append("f")
                        finalList.append("\(lineNumber).  f  --> [CHAR]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    }
                    
                    
                } else if y == "w" {
                    
                    if inputText[1] == "h" && inputText[2] == "i" && inputText[3] == "l" && inputText[4] == "e" {
                        //CHECKING FOR WHILE
                        finalList.append("\(lineNumber).  while  --> [WHILE]")
                        inputText.removeFirst(5)
                        lineNumber += 1
                        cleanList.append("while")
                        checkNext()
                        
                    } else if inputText[1] == "=" || inputText[1] == "!" {
                        //CHECKING FOR ASSIGNMENT
                        finalList.append("\(lineNumber).  w  --> [ID]")
                        cleanList.append("w")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                        
                        finalList.append("\(lineNumber).  w  --> [CHAR]")
                        cleanList.append("w")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    }
                    
                    
                } else if y == "p" {
                    
                    if inputText[1] == "r" && inputText[2] == "i" && inputText[3] == "n" && inputText[4] == "t" {
                        //CHECKING FOR PRINT
                        finalList.append("\(lineNumber).  print  --> [PRINT]")
                        cleanList.append("print")
                        inputText.removeFirst(5)
                        lineNumber += 1
                        checkNext()
                        
                    } else if inputText[1] == "=" || inputText[1] == "!" {
                        //CHECKING FOR ASSIGNMENT
                        finalList.append("\(lineNumber).  p  --> [ID]")
                        cleanList.append("p")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                        
                        finalList.append("\(lineNumber).  p  --> [CHAR]")
                        cleanList.append("p")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    }
                    
                    
                } else if y == "b" {
                    
                    if inputText[1] == "o" && inputText[2] == "o" && inputText[3] == "l" && inputText[4] == "e" && inputText[5] == "a" && inputText[6] == "n" {
                        //CHECKING FOR BOOLEAN
                        finalList.append("\(lineNumber).  boolean  --> [BOOLEAN]")
                        cleanList.append("boolean")
                        inputText.removeFirst(7)
                        lineNumber += 1
                        checkId()
                        
                    } else if inputText[1] == "=" || inputText[1] == "!" {
                        //CHECKING FOR ASSIGNMENT
                        finalList.append("\(lineNumber).  b  --> [ID]")
                        cleanList.append("b")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                        
                        finalList.append("\(lineNumber).  b  --> [CHAR]")
                        cleanList.append("b")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    }
                    
                    
                } else if y == "s" {
                    
                    if inputText[1] == "t" && inputText[2] == "r" && inputText[3] == "i" && inputText[4] == "n" && inputText[5] == "g" {
                        //CHECKING FOR STRING
                        cleanList.append("string")
                        finalList.append("\(lineNumber).  string  --> [STRING]")
                        inputText.removeFirst(6)
                        lineNumber += 1
                        checkId()
                        
                    } else if inputText[1] == "=" || inputText[1] == "!" {
                        //CHECKING FOR ASSIGNMENT
                        cleanList.append("s")
                        finalList.append("\(lineNumber).  s  --> [ID]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                        
                        cleanList.append("s")
                        finalList.append("\(lineNumber).  s  --> [CHAR]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    }
                    
                    
                } else if y == "{" {
                    
                    cleanList.append("{")
                    finalList.append("\(lineNumber).  {  --> [LBRACE]")
                    inputText.removeFirst()
                    lineNumber += 1
                    checkNext()
                    
                } else if y == "}" {
                    
                    cleanList.append("}")
                    finalList.append("\(lineNumber).  }  --> [RBRACE]")
                    inputText.removeFirst()
                    lineNumber += 1
                    checkNext()
                    
                } else if y == "(" {
                    
                    if acceptedChars.contains(String(describing: inputText[1])) && inputText[2] == ")" {
                        //CHECKING IF PARENTHESES CONTAIN IDENTIFIER
                        finalList.append("\(lineNumber).  (  --> [LPAREN]")
                        cleanList.append("(")
                        lineNumber += 1
                        cleanList.append(String(describing: inputText[1]))
                        finalList.append("\(lineNumber).  \(String(describing: inputText[1])) --> [ID]")
                        lineNumber += 1
                        cleanList.append(")")
                        finalList.append("\(lineNumber).  )  --> [RPAREN]")
                        lineNumber += 1
                        inputText.removeFirst(3)
                        checkNext()
                        
                    } else if (acceptedChars.contains(String(describing: inputText[1])) && (inputText[2] == "=")) && inputText[3] == "=" {
                        
                        cleanList.append("(")
                        finalList.append("\(lineNumber).  (  --> [LPAREN]")
                        lineNumber += 1
                        cleanList.append(String(describing: inputText[1]))
                        finalList.append("\(lineNumber).  \(String(describing: inputText[1])) --> [ID]")
                        lineNumber += 1
                        cleanList.append("==")
                        finalList.append("\(lineNumber).  ==  --> [BOOLOP]")
                        lineNumber += 1
                        inputText.removeFirst(4)
                        checkNext()
                        
                    } else if (acceptedChars.contains(String(describing: inputText[1])) && (inputText[2] == "!")) && inputText[3] == "=" {
                        
                        cleanList.append("(")
                        cleanList.append(String(describing: inputText[1]))
                        cleanList.append("!=")
                        finalList.append("\(lineNumber).  (  --> [LPAREN]")
                        lineNumber += 1
                        finalList.append("\(lineNumber).  \(String(describing: inputText[1])) --> [ID]")
                        lineNumber += 1
                        finalList.append("\(lineNumber).  !=  --> [BOOLOP]")
                        lineNumber += 1
                        inputText.removeFirst(4)
                        checkNext()
                        
                    } else {
                        
                        cleanList.append("(")
                        finalList.append("\(lineNumber).  (  --> [LPAREN]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    }
                    
                } else if y == ")" {
                    
                    cleanList.append(")")
                    finalList.append("\(lineNumber).  )  --> [RPAREN]")
                    inputText.removeFirst()
                    lineNumber += 1
                    checkNext()
                    
                } else if y == "$" {
                    //CHECKS FOR END-OF-PROGRAM AND CREATES NEW ONE
                    cleanList.append("$")
                    finalList.append("\(lineNumber).  $  --> [EOP]\n")
                    inputText.removeFirst()
                    lineNumber += 1
                    newProgram()
                    
                } else if y == "!" {
                    
                    if inputText[1] == "=" {
                        //CHECKING FOR BOOLOP
                        finalList.append("\(lineNumber).  !=  --> [BOOLOP]")
                        cleanList.append("!=")
                        inputText.removeFirst(2)
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                        
                        finalList.append("\(lineNumber).  ERROR: Unrecognized Token: \(inputText.first!) on line \(currentLine)")
                        inputText.removeFirst()
                        errorCount += 1
                        lineNumber += 1
                        checkNext()
                        
                    }
                    
                } else if y == "\n" {
                    
                    currentLine += 1
                    inputText.removeFirst()
                    checkNext()
                    
                } else if y == "=" {
                    
                    if inputText[1] == "=" {
                        //CHECKING FOR BOOLOP
                        finalList.append("\(lineNumber).  ==  --> [BOOLOP]")
                        cleanList.append("==")
                        lineNumber += 1
                        inputText.removeFirst(2)
                        checkNext()
                        
                    } else if (acceptedChars.contains(String(describing: inputText[1])) && String(describing: inputText[1]) != ("t") && String(describing: inputText[1]) != ("f"))  {
                        cleanList.append("=")
                        cleanList.append(String(describing: inputText[1]))
                        finalList.append("\(lineNumber).  =  --> [SINGLE_EQUALS]")
                        lineNumber += 1
                        finalList.append("\(lineNumber).  \(inputText[1])  --> [ID]")
                        lineNumber += 1
                        inputText.removeFirst(2)
                        checkNext()
                        
                    } else {
                        
                        cleanList.append("=")
                        finalList.append("\(lineNumber).  =  --> [SINGLE_EQUALS]")
                        lineNumber += 1
                        inputText.removeFirst()
                        checkNext()
                        
                    }
                    
                } else if intOp.contains(String(describing: y!)) {
                    
                    if acceptedChars.contains(String(describing: inputText[1])) {
                        
                        cleanList.append("+")
                        finalList.append("\(lineNumber).  +  --> [INTOP]")
                        lineNumber += 1
                        cleanList.append(String(describing: inputText[1]))
                        finalList.append("\(lineNumber).  \(String(describing: inputText[1]))  --> [ID]")
                        inputText.removeFirst(2)
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                        
                        cleanList.append("+")
                        finalList.append("\(lineNumber).  +  --> [INTOP]")
                        lineNumber += 1
                        inputText.removeFirst()
                        checkNext()
                        
                    }
                    
                } else if acceptedNums.contains(String(describing: y!)) {
                    
                    cleanList.append(String(describing: y!))
                    finalList.append("\(lineNumber).  \(y!)  --> [DIGIT]")
                    inputText.removeFirst()
                    lineNumber += 1
                    checkNext()
                    
                } else if acceptedChars.contains(String(describing: y!)) {
                    
                    if inputText[1] == "=" {
                    
                        cleanList.append(String(describing: y!))
                        finalList.append("\(lineNumber).  \(y!)  --> [ID]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                        
                    } else {
                        
                        cleanList.append(String(describing: y!))
                        finalList.append("\(lineNumber).  \(y!)  --> [CHAR]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    }
                    
                } else if (y == "\"" || y == "“") {
                    
                    cleanList.append("\"")
                    finalList.append("\(lineNumber).  \"  --> [OPEN_DOUBLE_QUOTE]")
                    inputText.removeFirst()
                    lineNumber += 1
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
                
                finalList.append("\(lineNumber).  ERROR: Unrecognized Token: \(inputText.first!) on line \(currentLine)")
                inputText.removeFirst()
                errorCount += 1
                lineNumber += 1
                startCharList()
                
            } else if acceptedChars.contains(String(describing:y)) {
                
                cleanList.append(String(describing: y))
                finalList.append("\(lineNumber).  \(y)  --> [Char]")
                inputText.removeFirst()
                lineNumber += 1
                startCharList()
                
            } else if y == " " {
                
                cleanList.append(String(describing: y))
                finalList.append("\(lineNumber).  \(y)  --> [WHITE_SPACE]")
                inputText.removeFirst()
                lineNumber += 1
                startCharList()
                
                
            } else if y == "$" || y == "\n" || y == "\t" {
                
                finalList.append("\(lineNumber).  ERROR: Unrecognized Token: \(inputText.first!) on line \(currentLine)")
                inputText.removeFirst()
                errorCount += 1
                lineNumber += 1
                startCharList()
                
            } else if y == "}" {
                
                cleanList.append("}")
                finalList.append("\(lineNumber).  }  --> [RBRACE]")
                lineNumber += 1
                inputText.removeFirst()
                warningLabel.stringValue = "Please don't forget to close quote"
                checkNext()
                
            } else if y == ")" {
            
                cleanList.append(")")
                finalList.append("\(lineNumber).  \"  --> [CLOSE_DOUBLE_QUOTES]")
                lineNumber += 1
                finalList.append("\(lineNumber).  )  --> [RPAREN]")
                lineNumber += 1
                inputText.removeFirst()
                warningLabel.stringValue = "Please don't forget to close quote"
                checkNext()
            
            } else {
                
                checkNext()
                
            }
            
        } else {
            
            cleanList.append("\"")
            finalList.append("\(lineNumber).  \"  --> [CLOSE_DOUBLE_QUOTES]")
            inputText.removeFirst()
            lineNumber += 1
            checkNext()
            
        }
        
    }
    
    func checkId() {
        //Checks to see if character is part of keyword
        if acceptedNums.contains(String(describing: inputText.first!)) || acceptedChars.contains(String(describing: inputText.first!)) {
            
            let y = inputText.first!
            cleanList.append(String(describing: y))
            finalList.append("\(lineNumber).  \(y)  --> [ID]")
            inputText.removeFirst()
            lineNumber += 1
            checkNext()
            
        } else {
            
            finalList.append("\(lineNumber).  ERROR: Unrecognized Token: \(inputText.first!) on line \(currentLine)")
            inputText.removeFirst()
            errorCount += 1
            lineNumber += 1
            checkNext()
            
        }
        
    }
    
    func newProgram() {
        //print(errorCount)
        if errorCount == 0 {
            
            if inputText.isEmpty == false {
                
                finalList.append("Lex completed program \(programNum) successfully.\n")
                ParseProgram()
                programNum += 1
                lineNumber = 0
                finalList.append("Lexing program \(programNum)...")
                checkNext()
                
            } else {
                
                finalList.append("Lex completed  program \(programNum) successfully.\n")
                programNum += 1
                lineNumber = 0
                ParseProgram()
                finalList.insert("Lex completed successfully!", at: 0)
                printFinal()
                
            }
            
        } else {
            
            if inputText.isEmpty == false {
                
                parsedList.string = ""
                finalList.append("Lex completed with \(errorCount) error(s).")
                lineNumber = 0
                errorCount = 0
                checkNext()
                
            } else {
                
                parsedList.string = ""
                lineNumber = 0
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
