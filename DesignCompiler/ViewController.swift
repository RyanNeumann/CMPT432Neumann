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
            inputText.append(enteredCode.text.characters.first!)
            enteredCode.text.characters.removeFirst()
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
                
                if inputText.isEmpty {
                    
                    printFinal()
                
                } else if y == " " {
                    
                    inputText.removeFirst()
                    checkNext()
                    
                } else if unacceptedList.contains(String(describing: y!)){
                    
                    //CHECK FOR ERRORS
                    finalList.append("\(lineNumber). ERROR: Unrecognized Token: \(y!) on line \(lineNumber)")
                    inputText.removeFirst()
                    errorCount += 1
                    lineNumber += 1
                    checkNext()
                    
                } else if y == "\"" {
                    finalList.append("\(lineNumber).  \"  --> [CharList]")
                    inputText.removeFirst()
                    lineNumber += 1
                    startCharList()
                    
                } else if y == "i" || y == "w" || y == "s" {
                    
                    checkKeyword()
                    
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
                    
                    finalList.append("\(lineNumber).  }  --> [LPAREN]")
                    inputText.removeFirst()
                    lineNumber += 1
                    checkNext()
                    
                } else if y == ")" {
                    
                    finalList.append("\(lineNumber).  }  --> [RPAREN]")
                    inputText.removeFirst()
                    lineNumber += 1
                    checkNext()
                    
                } else if y == "$" {
                    
                    finalList.append("\(lineNumber).  $  --> [EOP]")
                    inputText.removeFirst()
                    lineNumber += 1
                    newProgram()
                    
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
        
            if inputText.first == " " {
                inputText.removeFirst()
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
                
                }
            
            } else {
            
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
            
            }
        
        } else {
        
            finalList.append("\(lineNumber).  \"  --> [CharList]")
            inputText.removeFirst()
            lineNumber += 1
            checkNext()
            
        }
    
    
    }
    
    func checkKeyword() {
    //Checks to see if character is part of keyword
        var testArray = inputText
        
        if inputText.first == "i" {
            inputText.removeFirst()
            testArray.removeFirst()
            if testArray.first == "n" {
                testArray.removeFirst()
                inputText.removeFirst()
                if testArray.first == "t" {
                //Confirmed "int"
                    finalList.append("\(lineNumber).  int  --> [Keyword]")
                    inputText.removeFirst()
                    print(inputText)
                    lineNumber += 1
                    
                    if inputText.first == " " {
                        inputText.removeFirst()
                        
                        if acceptedChars.contains(String(describing: inputText.first!)) {
                            let z = inputText.first!
                            finalList.append("\(lineNumber).  \(z)  --> [Id]")
                            inputText.removeFirst()
                            lineNumber += 1
                            checkNext()
                            
                        } else if unacceptedList.contains(String(describing: inputText.first!)) {
                            
                            finalList.append("\(lineNumber).  ERROR: Unrecognized Token: \(inputText.first!) on line \(lineNumber)")
                            inputText.removeFirst()
                            errorCount += 1
                            lineNumber += 1
                            checkNext()
                            
                        } else {
                         
                            checkNext()
                            
                        }
                    } else {
                        //print(inputText)
                    
                        if acceptedNums.contains(String(describing: inputText.first!)) || acceptedChars.contains(String(describing: inputText.first!)) {
                            let y = inputText.first!
                            finalList.append("\(lineNumber).  \(y)  --> [Identifier]")
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
                } else {
                
                    finalList.append("\(lineNumber).  i  --> [Char]")
                    lineNumber += 1
                    finalList.append("\(lineNumber).  n  --> [Char]")
                    lineNumber += 1
                    checkNext()
                
                }
            
            } else if testArray.first == "f" {
            
                finalList.append("\(lineNumber).  if  --> [Keyword]")
                inputText.removeFirst()
                if inputText.first == " " {
                    inputText.removeFirst()
                    
                    if acceptedChars.contains(String(describing: inputText.first!)) {
                        let y = inputText.first!
                        finalList.append("\(lineNumber).  \(y)  --> [Identifier]")
                        inputText.removeFirst()
                        lineNumber += 1
                        
                        
                        checkNext()
                        
                    } else if unacceptedList.contains(String(describing: inputText.first!)) {
                        
                        finalList.append("\(lineNumber).  ERROR: Unrecognized Token: \(inputText.first!) on line \(lineNumber)")
                        inputText.removeFirst()
                        errorCount += 1
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                    
                        checkNext()
                    
                    }
                } else {
                    //print(inputText)
                    
                    if acceptedChars.contains(String(describing: inputText.first!)) {
                        let y = inputText.first!
                        finalList.append("\(lineNumber).  \(y)  --> [Identifier]")
                        inputText.removeFirst()
                        lineNumber += 1
                        
                        
                        checkNext()
                        
                    } else if unacceptedList.contains(String(describing: inputText.first!)) {
                        
                        finalList.append("\(lineNumber).  ERROR: Unrecognized Token: \(inputText.first!) on line \(lineNumber)")
                        inputText.removeFirst()
                        errorCount += 1
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                        
                        checkNext()
                        
                    }
                }
            } else {
            
                finalList.append("\(lineNumber).  i  --> [Char]")
                lineNumber += 1
                checkNext()
                
            }
        
        
        }
        
        if inputText.first == "w" {
            testArray.removeFirst()
            if testArray.first == "h" {
                testArray.removeFirst()
                if testArray.first == "i" {
                    testArray.removeFirst()
                    if testArray.first == "l" {
                        testArray.removeFirst()
                        if testArray.first == "e" {
                            finalList.append("\(lineNumber). while  --> [Keyword]")
                            inputText.removeFirst()
                            inputText.removeFirst()
                            inputText.removeFirst()
                            inputText.removeFirst()
                            inputText.removeFirst()
                            lineNumber += 1
                            //checkNext()
                            if inputText.first == " " {
                                inputText.removeFirst()
                                
                                if acceptedChars.contains(String(describing: inputText.first!)) {
                                    let y = inputText.first!
                                    finalList.append("\(lineNumber).  \(y)  --> [Identifier]")
                                    inputText.removeFirst()
                                    lineNumber += 1
                                    
                                    
                                    checkNext()
                                    
                                } else if unacceptedList.contains(String(describing: inputText.first!)) {
                                    
                                    finalList.append("\(lineNumber).  ERROR: Unrecognized Token: \(inputText.first!) on line \(lineNumber)")
                                    inputText.removeFirst()
                                    errorCount += 1
                                    lineNumber += 1
                                    checkNext()
                                    
                                } else {
                                    
                                    checkNext()
                                    
                                }
                            } else {
                                
                                if acceptedChars.contains(String(describing: inputText.first!)) {
                                    let y = inputText.first!
                                    finalList.append("\(lineNumber).  \(y)  --> [Identifier]")
                                    inputText.removeFirst()
                                    lineNumber += 1
                                    
                                    
                                    checkNext()
                                    
                                } else if unacceptedList.contains(String(describing: inputText.first!)) {
                                    
                                    finalList.append("\(lineNumber).  ERROR: Unrecognized Token: \(inputText.first!) on line \(lineNumber)")
                                    inputText.removeFirst()
                                    errorCount += 1
                                    lineNumber += 1
                                    checkNext()
                                    
                                } else {
                                    
                                    checkNext()
                                    
                                }
                                
                            }
                        
                            
                        } else {
                    
                            finalList.append("\(lineNumber).  w  --> [Char]")
                            lineNumber += 1
                            finalList.append("\(lineNumber).  h  --> [Char]")
                            lineNumber += 1
                            finalList.append("\(lineNumber).  i  --> [Char]")
                            lineNumber += 1
                            finalList.append("\(lineNumber).  l --> [Char]")
                            inputText.removeFirst()
                            inputText.removeFirst()
                            inputText.removeFirst()
                            inputText.removeFirst()
                            checkNext()
                        
                        
                        }
                    } else {
                        finalList.append("\(lineNumber).  w  --> [Char]")
                        lineNumber += 1
                        finalList.append("\(lineNumber).  h  --> [Char]")
                        lineNumber += 1
                        finalList.append("\(lineNumber).  i  --> [Char]")
                        inputText.removeFirst()
                        inputText.removeFirst()
                        inputText.removeFirst()
                        checkNext()
                        
                    }
                } else {
                    finalList.append("\(lineNumber).  w  --> [Char]")
                    lineNumber += 1
                    finalList.append("\(lineNumber).  h  --> [Char]")
                    inputText.removeFirst()
                    inputText.removeFirst()
                    checkNext()
                
                }
                
            } else {
            
                finalList.append("\(lineNumber).  w  --> [Char]")
                inputText.removeFirst()
                checkNext()

            }
            
        
        }
        
    
        if inputText.first == "s" {
            testArray.removeFirst()
            inputText.removeFirst()
            if testArray.first == "t" {
                testArray.removeFirst()
                if testArray.first == "r" {
                    testArray.removeFirst()
                    if testArray.first == "i" {
                        testArray.removeFirst()
                        if testArray.first == "n" {
                            testArray.removeFirst()
                            if testArray.first == "g" {
                                
                                finalList.append("\(lineNumber). string  --> [Keyword]")
                                inputText.removeFirst()
                                inputText.removeFirst()
                                inputText.removeFirst()
                                inputText.removeFirst()
                                inputText.removeFirst()
                                lineNumber += 1

                            
                                if inputText.first == " " {
                                    inputText.removeFirst()
                                    
                                    if acceptedNums.contains(String(describing: inputText.first!)) || acceptedChars.contains(String(describing: inputText.first!)) {
                                        let y = inputText.first!
                                        finalList.append("\(lineNumber).  \(y)  --> [Identifier]")
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
                                } else {
                                    
                                    if acceptedNums.contains(String(describing: inputText.first!)) || acceptedChars.contains(String(describing: inputText.first!)) {
                                        let y = inputText.first!
                                        finalList.append("\(lineNumber).  \(y)  --> [Identifier]")
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

                            
                                
                            } else {
                            
                                finalList.append("\(lineNumber).  s  --> [Char]")
                                lineNumber += 1
                                finalList.append("\(lineNumber).  t  --> [Char]")
                                lineNumber += 1
                                finalList.append("\(lineNumber).  r  --> [Char]")
                                lineNumber += 1
                                finalList.append("\(lineNumber).  i  --> [Char]")
                                lineNumber += 1
                                finalList.append("\(lineNumber).  n  --> [Char]")
                                lineNumber += 1
                                inputText.removeFirst()
                                inputText.removeFirst()
                                inputText.removeFirst()
                                inputText.removeFirst()
                                checkNext()
                                
                            
                            
                            }
                            
                            
                            
                        } else {
                        
                            finalList.append("\(lineNumber).  s  --> [Char]")
                            lineNumber += 1
                            finalList.append("\(lineNumber).  t  --> [Char]")
                            lineNumber += 1
                            finalList.append("\(lineNumber).  r  --> [Char]")
                            lineNumber += 1
                            finalList.append("\(lineNumber).  i  --> [Char]")
                            lineNumber += 1
                            inputText.removeFirst()
                            inputText.removeFirst()
                            inputText.removeFirst()
                            checkNext()
                            
                            
                            
                        }
                        
                        
                    
                    } else {
                        
                        finalList.append("\(lineNumber).  s  --> [Char]")
                        lineNumber += 1
                        finalList.append("\(lineNumber).  t  --> [Char]")
                        lineNumber += 1
                        finalList.append("\(lineNumber).  r  --> [Char]")
                        lineNumber += 1
                        inputText.removeFirst()
                        inputText.removeFirst()
                        checkNext()
                    
                    
                    }
                
                
                } else {
                    
                    finalList.append("\(lineNumber).  s  --> [Char]")
                    lineNumber += 1
                    finalList.append("\(lineNumber).  t  --> [Char]")
                    lineNumber += 1
                    inputText.removeFirst()
                    checkNext()

                
                }
                
            
            } else {
                
                finalList.append("\(lineNumber).  s  --> [Char]")
                lineNumber += 1
                checkNext()
                
            }
        
        
        
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

