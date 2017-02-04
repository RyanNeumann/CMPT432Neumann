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
        
        var y = inputText.first
        
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
                
                }
                
                if y == "\"" {
                    finalList.append("\(lineNumber).  \"  --> [CharList]")
                    inputText.removeFirst()
                    lineNumber += 1
                    startCharList()
                    
                }
                
                if y == "i" || y == "w" || y == "s" {
                    
                    checkKeyword()
                    
                }
                
                if y == "A" || y == "B" || y == "C" || y == "D" || y == "E" || y == "F" || y == "G" || y == "H" || y == "I" || y == "J" || y == "K" || y == "L" || y == "M" || y == "N" || y == "O" || y == "P" || y == "Q" || y == "R" || y == "S" || y == "T" || y == "U" || y == "V" || y == "W" || y == "X" || y == "Y" || y == "Z" || y == "@" || y == "^" || y == "_" || y == "#" || y == "!" || y == "&" || y == "*"{
                    
                    
                    //CHECK FOR ERRORS
                    finalList.append("\(lineNumber). ERROR: Unrecognized Token: \(y!) on line \(lineNumber)")
                    inputText.removeFirst()
                    errorCount += 1
                    lineNumber += 1
                    checkNext()
                    
                }
                
                if y == "{" {
                    
                    finalList.append("\(lineNumber).  {  --> [LBRACE]")
                    inputText.removeFirst()
                    lineNumber += 1
                    checkNext()
                }
                
                if y == "}" {
                    
                    finalList.append("\(lineNumber).  }  --> [RBRACE]")
                    inputText.removeFirst()
                    
                    lineNumber += 1
                    checkNext()
                }
                
                if y == "$" {
                    
                    finalList.append("\(lineNumber).  $  --> [EOP]")
                    inputText.removeFirst()
                    lineNumber += 1
                    newProgram()
                    
                }
                
                if y == "\n" {
                    
                    inputText.removeFirst()
                    checkNext()
                    
                }
                
                if y == " " {
                    
                    inputText.removeFirst()
                    checkNext()
                    
                }
                
                if y == "=" {
                    
                    finalList.append("\(lineNumber).  = --> [OP]")
                    lineNumber += 1
                    inputText.removeFirst()
                    checkNext()
                    
                }
                
                if y == "+" {
                    
                    finalList.append("\(lineNumber).  + --> [OP]")
                    lineNumber += 1
                    inputText.removeFirst()
                    checkNext()
                    
                }
                if y == "0" || y == "1" || y == "2" || y == "3" || y == "4" || y == "5" || y == "6" || y == "7" || y == "8" || y == "9" {
                    
                    finalList.append("\(lineNumber).  \(y!)  --> [Digit]")
                    inputText.removeFirst()
                    lineNumber += 1
                    checkNext()
                    
                }
                
                
            
                if y == "a" || y == "b" || y == "c" || y == "d" || y == "e" || y == "f" || y == "g" || y == "h" || y == "j" || y == "k" || y == "l" || y == "m" || y == "n" || y == "o" || y == "p" || y == "q" || y == "r" ||  y == "t" || y == "u" || y == "v" || y == "x" || y == "y" || y == "z" {
                    
                    finalList.append("\(lineNumber).  \(y!)  --> [Char]")
                    inputText.removeFirst()
                    lineNumber += 1
                    checkNext()
                    
                } else {
                    
                    checkNext()
                
                }
                
             //   print(lineNumber)
                
            }

        }
    }
    
    var acceptedList = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    
    func startCharList() {
    
        if inputText.first != "\"" {
        
            if inputText.first == " " {
                inputText.removeFirst()
                if inputText.first == "0" || inputText.first == "1" || inputText.first == "2" || inputText.first == "3" || inputText.first == "4" || inputText.first == "5" || inputText.first == "6" || inputText.first == "7" || inputText.first == "8" || inputText.first == "9" {
                
                    finalList.append("\(lineNumber).  \(inputText.first)  --> [Digit]")
                    inputText.removeFirst()
                    lineNumber += 1
                    startCharList()
                    
                } else {
                
                    finalList.append("\(lineNumber).  \(inputText.first)  --> [Char]")
                    inputText.removeFirst()
                    lineNumber += 1
                    startCharList()
                
                }
            
            } else {
            
                if inputText.first == "0" || inputText.first == "1" || inputText.first == "2" || inputText.first == "3" || inputText.first == "4" || inputText.first == "5" || inputText.first == "6" || inputText.first == "7" || inputText.first == "8" || inputText.first == "9" {
                    
                    finalList.append("\(lineNumber).  \(inputText.first)  --> [Digit]")
                    inputText.removeFirst()
                    lineNumber += 1
                    startCharList()
                    
                } else if acceptedList.contains(String(describing: inputText.first)) {
                    
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
                        
                        if acceptedList.contains(String(describing: inputText.first!)) {
                            let z = inputText.first!
                            finalList.append("\(lineNumber).  \(z)  --> [Identifier]")
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
                        //print(inputText)
                    
                        if acceptedList.contains(String(describing: inputText.first!)) {
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
                    inputText.removeFirst()
                    inputText.removeFirst()
                    checkNext()
                
                }
            
            } else if testArray.first == "f" {
            
                finalList.append("\(lineNumber).  if  --> [Keyword]")
                inputText.removeFirst()
                if inputText.first == " " {
                    inputText.removeFirst()
                    
                    if acceptedList.contains(String(describing: inputText.first!)) {
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
                    //print(inputText)
                    
                    if acceptedList.contains(String(describing: inputText.first!)) {
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
            
                finalList.append("\(lineNumber).  i  --> [char]")
                inputText.removeFirst()
                checkNext()
                
            }
        
        
        } else {
        
            print("Fuck")
        
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
                                
                                if acceptedList.contains(String(describing: inputText.first!)) {
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
                                
                                if acceptedList.contains(String(describing: inputText.first!)) {
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
                                    
                                    if acceptedList.contains(String(describing: inputText.first!)) {
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
                                    
                                    if acceptedList.contains(String(describing: inputText.first!)) {
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

