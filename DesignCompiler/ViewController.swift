//
//  ViewController.swift
//  DesignCompiler
//
//  Created by Ryan Neumann on 2/4/17.
//  Copyright © 2017 RyanNeumann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var enteredCode: UITextView!
    
    @IBOutlet weak var tokenList: UITextView!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    var inputText = [Character]()
    
    var textEntered: String = ""
    
    let unacceptedList = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "@", "%", "&", "*", "_", "-"]
    
    let acceptedChars = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    let acceptedNums = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    let boolOp = ["==", "!="]
    
    let boolVal = ["true", "false"]
    
    let intOp = "+"
    
    @IBAction func compile(_ sender: Any) {
        
        //Compile button pressed and function activated.
        if enteredCode.text != "" {
            
            if textEntered == "" {
            
                textEntered = enteredCode.text
                
            }
            
            //Used to clear the entered code and create an array that will be cycled through
            if enteredCode.text.characters.first == " " {
                
                enteredCode.text.characters.removeFirst()
            
            } else {
                
                inputText.append(enteredCode.text.characters.first!)
                enteredCode.text.characters.removeFirst()
                
            }
            finalList.removeAll(keepingCapacity: false)
            tokenList.text = ""
            compile(self)
            
        
        } else {
            
            if inputText.last != "$" {
            
                inputText.append("$")
                warningLabel.text = "Please use '$' to end the program!"
            
            } else {
                
                warningLabel.text = ""
            
            }
            enteredCode.text = textEntered
            textEntered = ""
            errorCount = 0
            lineNumber = 0
            programNum = 1
            checkNext()
        
        }
        
    }
    var lineNumber = 0
    var programNum = 1
    var errorCount = 0
    
    func checkNext() {
        
        let y = inputText.first
        
        if y == nil {
            
            printFinal()
        } else {
        
            if finalList.isEmpty {
                //Processing Program 1
                finalList.append("Lexing program 1...")
                programNum += 1
                checkNext()
                
            } else {
                
                if unacceptedList.contains(String(describing: y!)){
                    
                    //CHECK FOR ERRORS
                    finalList.append("\(lineNumber). ERROR: Unrecognized Token: \(y!) on line \(lineNumber)")
                    inputText.removeFirst()
                    errorCount += 1
                    lineNumber += 1
                    checkNext()
                    
                } else if y == "i" {
                    
                    if inputText[1] == "n" && inputText[2] == "t" {
                        finalList.append("\(lineNumber).  int  --> [TYPE]")
                        inputText.removeFirst()
                        inputText.removeFirst()
                        inputText.removeFirst()
                        lineNumber += 1
                        checkId()
                        
                    } else if inputText[1] == "f" {
                        
                        finalList.append("\(lineNumber).  int  --> [TYPE]")
                        inputText.removeFirst()
                        inputText.removeFirst()
                        lineNumber += 1
                        checkId()
                    
                    } else {
                        
                        finalList.append("\(lineNumber).  i --> [Char]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                    
                    }
            
                } else if y == "t" {
                    if inputText[1] == "r" && inputText[2] == "u" && inputText[3] == "e" {
                    
                        finalList.append("\(lineNumber).  true --> [TRUE]")
                        inputText.removeFirst()
                        inputText.removeFirst()
                        inputText.removeFirst()
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                    
                    } else {
                        
                        finalList.append("\(lineNumber).  t  --> [Char]")
                        finalList.removeFirst()
                        lineNumber += 1
                        checkNext()
                    }
                    
                } else if y == "f" {
                
                    if inputText[1] == "a" && inputText[2] == "l" && inputText[3] == "s" && inputText[4] == "e" {
                    
                        finalList.append("\(lineNumber).  false  --> [FALSE]")
                        inputText.removeFirst()
                        inputText.removeFirst()
                        inputText.removeFirst()
                        inputText.removeFirst()
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                    
                    } else {
                    
                        finalList.append("\(lineNumber).  f  --> [Char]")
                        finalList.removeFirst()
                        lineNumber += 1
                        checkNext()
                    
                    }
                    
                } else if y == "p" {
                    
                    if inputText[1] == "r" && inputText[2] == "i" && inputText[3] == "n" && inputText[4] == "t" {
                     
                        finalList.append("\(lineNumber).  print  --> [PRINT]")
                        inputText.removeFirst()
                        inputText.removeFirst()
                        inputText.removeFirst()
                        inputText.removeFirst()
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                    
                        finalList.append("\(lineNumber).  p  --> [Char]")
                    
                    }
                    
                } else if y == "b" {
                    
                    if inputText[1] == "o" && inputText[2] == "o" && inputText[3] == "l" && inputText[4] == "e" && inputText[5] == "a" && inputText[6] == "n" {
                        
                        finalList.append("\(lineNumber).  boolean  --> [TYPE]")
                        inputText.removeFirst()
                        inputText.removeFirst()
                        inputText.removeFirst()
                        inputText.removeFirst()
                        inputText.removeFirst()
                        inputText.removeFirst()
                        inputText.removeFirst()
                        lineNumber += 1
                        checkId()
                        
                    } else {
                    
                        finalList.append("\(lineNumber).  b  --> [Char]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                    
                    }
                
                
                } else if y == "{" {
                    
                    finalList.append("\(lineNumber).  {  --> [LBRACE]")
                    inputText.removeFirst()
                    lineNumber += 1
                    checkNext()
                    
                } else if y == "}" {
                    
                    finalList.append("\(lineNumber).  }  --> [RBRACE]")
                    inputText.removeFirst()
                    lineNumber += 1
                    checkNext()
                    
                } else if y == "(" {
                    
                    finalList.append("\(lineNumber).  (  --> [LPAREN]")
                    inputText.removeFirst()
                    lineNumber += 1
                    checkNext()
                    
                } else if y == ")" {
                    
                    finalList.append("\(lineNumber).  )  --> [RPAREN]")
                    inputText.removeFirst()
                    lineNumber += 1
                    checkNext()
                    
                } else if y == "$" {
                    
                    finalList.append("\(lineNumber).  $  --> [EOP]")
                    inputText.removeFirst()
                    lineNumber += 1
                    newProgram()
                    
                } else if y == "!" {
                    if inputText[1] == "=" {
                    
                        finalList.append("\(lineNumber).  !=  --> [BoolOp]")
                        inputText.removeFirst()
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                    
                    } else {
                    
                        finalList.append("\(lineNumber).  !  --> [RBRACE]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    }
                } else if y == "\n" {
                    
                    inputText.removeFirst()
                    checkNext()
                    
                } else if y == "=" {
                    if inputText[1] == "=" {
                        //boolOp
                        finalList.append("\(lineNumber).  == --> [BoolOp]")
                        lineNumber += 1
                        inputText.removeFirst()
                        inputText.removeFirst()
                        checkNext()
                    
                    } else {
                    
                        finalList.append("\(lineNumber).  = --> [OP]")
                        lineNumber += 1
                        inputText.removeFirst()
                        checkNext()
                
                    }
                    
                } else if intOp.contains(String(describing: y!)) {
                    
                    finalList.append("\(lineNumber).  + --> [OP]")
                    lineNumber += 1
                    inputText.removeFirst()
                    checkNext()
                    
                } else if acceptedNums.contains(String(describing: y!)) {
                    
                    finalList.append("\(lineNumber).  \(y!)  --> [Digit]")
                    inputText.removeFirst()
                    lineNumber += 1
                    checkNext()
                    
                } else if acceptedChars.contains(String(describing: y!)) {
                    
                    finalList.append("\(lineNumber).  \(y!)  --> [Char]")
                    inputText.removeFirst()
                    lineNumber += 1
                    checkNext()
                    
                } else if y == "\t" {
                
                    inputText.removeFirst()
                    checkNext()
                
               } else if y == "\"" {
                
                finalList.append("\(lineNumber).  \"  --> [CharList]")
                inputText.removeFirst()
                lineNumber += 1
                startCharList()
                
               } else {
                    print(inputText)
                    printFinal()
                
                }
                
            }

        }
    }
    
    func checkBoolOp() {
    //Checking if token is != or ==
    
    }
    
    func startCharList() {
    
        if inputText.first != "\"" {
            
                if acceptedNums.contains(String(describing: inputText.first!)) {
                    
                    finalList.append("\(lineNumber).  \(inputText.first)  --> [Digit]")
                    inputText.removeFirst()
                    lineNumber += 1
                    startCharList()
                    
                } else if acceptedChars.contains(String(describing: inputText.first!)) {
                    
                    finalList.append("\(lineNumber).  \(inputText.first)  --> [Char]")
                    inputText.removeFirst()
                    lineNumber += 1
                    startCharList()
                    
                } else {
                    
                    checkNext()
                
                }
        
        } else {
        
            finalList.append("\(lineNumber).  \"  --> [CharList]")
            inputText.removeFirst()
            lineNumber += 1
            checkNext()
            
        }
    
    
    }
    
    func checkId() {
    //Checks to see if character is part of keyword
        if acceptedNums.contains(String(describing: inputText.first!)) || acceptedChars.contains(String(describing: inputText.first!)) {
            let y = inputText.first!
            finalList.append("\(lineNumber).  \(y)  --> [ID]")
            inputText.removeFirst()
            lineNumber += 1
            checkNext()
            
        } else {
            
            finalList.append("\(lineNumber).  ERROR: Unrecognized Token: \(inputText.first!) on line \(lineNumber)")
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
                finalList.append("Lex completed successfully.")
                finalList.append("\n")
                finalList.append("Lexing program \(programNum)...")
                programNum += 1
                checkNext()
                
            } else {
                
                finalList.append("Lex completed successfully.")
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
    
    
    var finalList = [String]()
    func printFinal() {
        
        tokenList.text = ""
        inputText = []
        
        for element in finalList {
        
            tokenList.text.append(element + "\n")
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

