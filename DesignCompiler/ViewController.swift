//
//  ViewController.swift
//  DesignCompiler
//
//  Created by Ryan Neumann on 2/4/17.
//  Copyright © 2017 RyanNeumann. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    @IBOutlet weak var enteredCode: UITextView!
    
    @IBOutlet weak var tokenList: UITextView!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var compileButton: UIButton!
    var inputText = [Character]()
    
    var textEntered: String = ""
    
    let unacceptedList = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "@", "%", "&", "*", "_", "-", "#", "~", "`", "^", "|"]
    
    let acceptedChars = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    let acceptedNums = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    let boolOp = ["==", "!="]
    
    let boolVal = ["true", "false"]
    
    let intOp = "+"
    
    @IBOutlet weak var examplePicker: UIPickerView!
    
    @IBAction func compile(_ sender: Any) {
        
        enteredCode.resignFirstResponder()
        
        //Compile button pressed and function activated.
        if enteredCode.text != "" {
            
            if textEntered == "" {
            
                textEntered = enteredCode.text
                
            }
            
            //Used to clear the entered code and create an array that will be cycled through
            
            if enteredCode.text.characters.first == "\"" {
                
                inputText.append(enteredCode.text.characters.first!)
                enteredCode.text.characters.removeFirst()
                
                while (enteredCode.text.characters.first != "\"") == true {
                    print(enteredCode.text.characters.first!)
                    inputText.append(enteredCode.text.characters.first!)
                    enteredCode.text.characters.removeFirst()
                
                }
                
                if enteredCode.text.characters.first == "\"" {
                    
                    inputText.append(enteredCode.text.characters.first!)
                    enteredCode.text.characters.removeFirst()
                
                }
                
            } else if enteredCode.text.characters.first == " " {
                
                
                enteredCode.text.characters.removeFirst()
                
            } else {
            
                inputText.append(enteredCode.text.characters.first!)
                enteredCode.text.characters.removeFirst()
                
            }
            
            finalList.removeAll(keepingCapacity: false)
            tokenList.text = ""
            compile(self)
        
        } else {
            //CHECK IF EOP($) IS MISSING
            if inputText.last != "$" {
            
                inputText.append("$")
                warningLabel.text = "Please use '$' to end the program! \n One has been added for you."
                enteredCode.text = textEntered.appending("$")
            
            } else {
                
                warningLabel.text = ""
                enteredCode.text = textEntered
                
            }
            
            
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
        //print(y)
        
        //If y is empty, print the final list of tokens
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
                    //NO ERRORS... CHECKING NEXT CHARACTER
                    if inputText[1] == "n" && inputText[2] == "t" {
                        //CHECKING FOR INT
                        finalList.append("\(lineNumber).  int  --> [INT]")
                        inputText.removeFirst(3)
                        lineNumber += 1
                        checkId()
                        
                    } else if inputText[1] == "f" {
                        //CHECKING FOR IF
                        finalList.append("\(lineNumber).  if  --> [TYPE]")
                        inputText.removeFirst(2)
                        lineNumber += 1
                        checkNext()
                    
                    } else if ((inputText[1] == "=") ||  (inputText[1] == "!")) {
                        //CHECKING FOR ASSIGNMENT
                        finalList.append("\(lineNumber).  i  --> [ID]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                        
                        finalList.append("\(lineNumber).  i  --> [CHAR]")
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
                        inputText.removeFirst(4)
                        lineNumber += 1
                        checkNext()
                    
                    } else if inputText[1] == "=" || inputText[1] == "!" {
                        //CHECKING FOR ASSIGNMENT
                        finalList.append("\(lineNumber).  t  --> [ID]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                        
                        finalList.append("\(lineNumber).  t  --> [CHAR]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    }
                    
                } else if y == "f" {
                
                    if inputText[1] == "a" && inputText[2] == "l" && inputText[3] == "s" && inputText[4] == "e" {
                        //CHECKING FOR FALSE
                        finalList.append("\(lineNumber).  false  --> [FALSE]")
                        inputText.removeFirst(5)
                        lineNumber += 1
                        checkNext()
                    
                    } else if inputText[1] == "=" || inputText[1] == "!" {
                        //CHECKING FOR ASSIGNMENT
                        finalList.append("\(lineNumber).  f  --> [ID]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                        
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
                        checkNext()
                        
                    } else if inputText[1] == "=" || inputText[1] == "!" {
                        //CHECKING FOR ASSIGNMENT
                        finalList.append("\(lineNumber).  w  --> [ID]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                        
                        finalList.append("\(lineNumber).  w  --> [CHAR]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    }
                    
                    
                } else if y == "p" {
                    
                    if inputText[1] == "r" && inputText[2] == "i" && inputText[3] == "n" && inputText[4] == "t" {
                        //CHECKING FOR PRINT
                        finalList.append("\(lineNumber).  print  --> [PRINT]")
                        inputText.removeFirst(5)
                        lineNumber += 1
                        checkNext()
                        
                    } else if inputText[1] == "=" || inputText[1] == "!" {
                        //CHECKING FOR ASSIGNMENT
                        finalList.append("\(lineNumber).  p  --> [ID]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                        
                        finalList.append("\(lineNumber).  p  --> [CHAR]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    }

                    
                } else if y == "b" {
                    
                    if inputText[1] == "o" && inputText[2] == "o" && inputText[3] == "l" && inputText[4] == "e" && inputText[5] == "a" && inputText[6] == "n" {
                        //CHECKING FOR BOOLEAN
                        finalList.append("\(lineNumber).  boolean  --> [BOOLEAN]")
                        inputText.removeFirst(7)
                        lineNumber += 1
                        checkId()
                        
                    } else if inputText[1] == "=" || inputText[1] == "!" {
                        //CHECKING FOR ASSIGNMENT
                        finalList.append("\(lineNumber).  b  --> [ID]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                        
                        finalList.append("\(lineNumber).  b  --> [CHAR]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                    
                    }
                
                
                } else if y == "s" {
                    
                    if inputText[1] == "t" && inputText[2] == "r" && inputText[3] == "i" && inputText[4] == "n" && inputText[5] == "g" {
                        //CHECKING FOR STRING
                        finalList.append("\(lineNumber).  string  --> [STRING]")
                        inputText.removeFirst(6)
                        lineNumber += 1
                        checkId()
                        
                    } else if inputText[1] == "=" || inputText[1] == "!" {
                        //CHECKING FOR ASSIGNMENT
                        finalList.append("\(lineNumber).  s  --> [ID]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    } else {
                        
                        finalList.append("\(lineNumber).  s  --> [CHAR]")
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
                    
                    if acceptedChars.contains(String(describing: inputText[1])) && inputText[2] == ")" {
                        //CHECKING IF PARENTHESES CONTAIN IDENTIFIER
                        finalList.append("\(lineNumber).  (  --> [LPAREN]")
                        lineNumber += 1
                        finalList.append("\(lineNumber).  \(String(describing: inputText[1])) --> [ID]")
                        lineNumber += 1
                        finalList.append("\(lineNumber).  )  --> [RPAREN]")
                        lineNumber += 1
                        inputText.removeFirst(3)
                        checkNext()
                    
                    } else if (acceptedChars.contains(String(describing: inputText[1])) && (inputText[2] == "=")) && inputText[3] == "=" {
                        
                        finalList.append("\(lineNumber).  (  --> [LPAREN]")
                        lineNumber += 1
                        finalList.append("\(lineNumber).  \(String(describing: inputText[1])) --> [ID]")
                        lineNumber += 1
                        finalList.append("\(lineNumber).  ==  --> [BOOLOP]")
                        lineNumber += 1
                        inputText.removeFirst(4)
                        checkNext()
                    
                    } else if (acceptedChars.contains(String(describing: inputText[1])) && (inputText[2] == "!")) && inputText[3] == "=" {
                        
                        finalList.append("\(lineNumber).  (  --> [LPAREN]")
                        lineNumber += 1
                        finalList.append("\(lineNumber).  \(String(describing: inputText[1])) --> [ID]")
                        lineNumber += 1
                        finalList.append("\(lineNumber).  !=  --> [BOOLOP]")
                        lineNumber += 1
                        inputText.removeFirst(4)
                        checkNext()
                        
                    } else {
                        
                        finalList.append("\(lineNumber).  (  --> [LPAREN]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                    
                    }
                    
                } else if y == ")" {
                    
                    finalList.append("\(lineNumber).  )  --> [RPAREN]")
                    inputText.removeFirst()
                    lineNumber += 1
                    checkNext()
                    
                } else if y == "$" {
                    //CHECKS FOR END-OF-PROGRAM AND CREATES NEW ONE
                    finalList.append("\(lineNumber).  $  --> [EOP]")
                    inputText.removeFirst()
                    lineNumber += 1
                    newProgram()
                    
                } else if y == "!" {
                    
                    if inputText[1] == "=" {
                        //CHECKING FOR BOOLOP
                        finalList.append("\(lineNumber).  !=  --> [BOOLOP]")
                        inputText.removeFirst(2)
                        lineNumber += 1
                        checkNext()
                    
                    } else {
                    
                        finalList.append("\(lineNumber).  ERROR: Unrecognized Token: \(inputText.first!) on line \(lineNumber)")
                        inputText.removeFirst()
                        errorCount += 1
                        lineNumber += 1
                        checkNext()
                        
                    }
                    
                } else if y == "\n" {
                    
                    inputText.removeFirst()
                    checkNext()
                    
                } else if y == "=" {
                    
                    if inputText[1] == "=" {
                        //CHECKING FOR BOOLOP
                        finalList.append("\(lineNumber).  ==  --> [BOOLOP]")
                        lineNumber += 1
                        inputText.removeFirst(2)
                        checkNext()
                    
                    } else if (acceptedChars.contains(String(describing: inputText[1])) && String(describing: inputText[1]) != ("t") && String(describing: inputText[1]) != ("f"))  {
                        
                        finalList.append("\(lineNumber).  =  --> [SINGLE_EQUALS]")
                        lineNumber += 1
                        finalList.append("\(lineNumber).  \(inputText[1])  --> [ID]")
                        lineNumber += 1
                        inputText.removeFirst(2)
                        checkNext()
                
                    } else {
                    
                        finalList.append("\(lineNumber).  =  --> [SINGLE_EQUALS]")
                        lineNumber += 1
                        inputText.removeFirst()
                        checkNext()
                        
                    }
                    
                } else if intOp.contains(String(describing: y!)) {
                    
                    if acceptedChars.contains(String(describing: inputText[1])) {
                    
                        finalList.append("\(lineNumber).  +  --> [INTOP]")
                        lineNumber += 1
                        finalList.append("\(lineNumber).  \(String(describing: inputText[1]))  --> [ID]")
                        inputText.removeFirst(2)
                        lineNumber += 1
                        checkNext()
                    
                    } else {
                    
                        finalList.append("\(lineNumber).  +  --> [INTOP]")
                        lineNumber += 1
                        inputText.removeFirst()
                        checkNext()
                    
                    }
                    
                } else if acceptedNums.contains(String(describing: y!)) {
                    
                    finalList.append("\(lineNumber).  \(y!)  --> [DIGIT]")
                    inputText.removeFirst()
                    lineNumber += 1
                    checkNext()
                    
                } else if acceptedChars.contains(String(describing: y!)) {
                    
                    if inputText[1] == "=" {
                        
                        finalList.append("\(lineNumber).  \(y!)  --> [ID]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()

                    
                    } else {
                        
                        finalList.append("\(lineNumber).  \(y!)  --> [CHAR]")
                        inputText.removeFirst()
                        lineNumber += 1
                        checkNext()
                        
                    }
                    
                } else if y == "\"" {
                
                    finalList.append("\(lineNumber).  \"  --> [CHARLIST]")
                    inputText.removeFirst()
                    lineNumber += 1
                    startCharList()
                
                } else if y == " " {
                    
                    inputText.removeFirst()
                    checkNext()
                
                } else {
                    
                    print(inputText)
                    printFinal()
                
                }
                
            }

        }
    }
    
    

    func startCharList() {
        
        if inputText.first != "\"" {
            
            let y = inputText.first!
        
            if acceptedNums.contains(String(describing:y)) {
                    
                finalList.append("\(lineNumber).  \(y)  --> [DIGIT]")
                inputText.removeFirst()
                lineNumber += 1
                startCharList()
                    
            } else if acceptedChars.contains(String(describing:y)) {
                    
                finalList.append("\(lineNumber).  \(y)  --> [CHAR]")
                inputText.removeFirst()
                lineNumber += 1
                startCharList()
                    
            } else if y == " " {
            
                finalList.append("\(lineNumber).  \(y)  --> [WHITE_SPACE]")
                inputText.removeFirst()
                lineNumber += 1
                startCharList()
            
            
            } else {
                    
                checkNext()
                
            }
        
        } else {
        
            finalList.append("\(lineNumber).  \"  --> [CHARLIST]")
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
        
        compileButton.layer.cornerRadius = 10
        enteredCode.layer.cornerRadius = 10
        tokenList.layer.cornerRadius = 10
        examplePicker.dataSource = self
        examplePicker.delegate = self
        examplePicker.layer.cornerRadius = 10
        
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        
        if row == 0 {
            
            let myTitle = NSAttributedString(string: "Example 1: Minimal", attributes: [NSFontAttributeName:UIFont(name: "Courier New", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
            
        } else if row == 1 {
            
            let myTitle = NSAttributedString(string: "Example 2: Declarations", attributes: [NSFontAttributeName:UIFont(name: "Courier New", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
            
        } else if row == 2 {
            
            let myTitle = NSAttributedString(string: "Example 3: Assignment 1", attributes: [NSFontAttributeName:UIFont(name: "Courier New", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
            
        } else if row == 3 {
            
            let myTitle = NSAttributedString(string: "Example 4: Assignment 2", attributes: [NSFontAttributeName:UIFont(name: "Courier New", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
            
        } else if row == 4 {
            
            let myTitle = NSAttributedString(string: "Example 5: Print 1", attributes: [NSFontAttributeName:UIFont(name: "Courier New", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
            
        } else if row == 5 {
            
            let myTitle = NSAttributedString(string: "Example 6: Print 2", attributes: [NSFontAttributeName:UIFont(name: "Courier New", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
            
        } else if row == 6 {
            
            let myTitle = NSAttributedString(string: "Example 7: String 1", attributes: [NSFontAttributeName:UIFont(name: "Courier New", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
            
        } else if row == 7 {
            
            let myTitle = NSAttributedString(string: "Example 8: String 2", attributes: [NSFontAttributeName:UIFont(name: "Courier New", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
            
        } else if row == 8 {
            
            let myTitle = NSAttributedString(string: "Example 9: Addition", attributes: [NSFontAttributeName:UIFont(name: "Courier New", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
            
        } else if row == 9 {
            
            let myTitle = NSAttributedString(string: "Example 10: If Statement", attributes: [NSFontAttributeName:UIFont(name: "Courier New", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
            
        } else if row == 10 {
            
            let myTitle = NSAttributedString(string: "Example 11: Boolean", attributes: [NSFontAttributeName:UIFont(name: "Courier New", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
            
        } else if row == 11 {
            
            let myTitle = NSAttributedString(string: "Example 12: While", attributes: [NSFontAttributeName:UIFont(name: "Courier New", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
            
        } else {
            
            let myTitle = NSAttributedString(string: "Etc.", attributes: [NSFontAttributeName:UIFont(name: "Courier New", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
            
        }

    }
    
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 12
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row == 0 {
        
            enteredCode.text = "{ }$"
            compile(self)
        
        }
        
        if row == 1 {
        
            enteredCode.text = "{\n\tint x\n\tstring s\n\tboolean b\n}$"
            compile(self)
        
        }
        
        if row == 2 {
            
            enteredCode.text = "{\n\tint a\n\ta = 1\n}$"
            compile(self)
            
        }
        
        if row == 3 {
            
            enteredCode.text = "{\n\tint a\n\ta = 1\n\n\tint b\n\tb = 2\n\n\ta = b\n\tb = a\n}$"
            compile(self)
            
        }
        
        if row == 4 {
            
            enteredCode.text = "{\n\tprint(1)\n}$"
            compile(self)
            
        }
        
        if row == 5 {
            
            enteredCode.text = "{\n\tprint(\"hello world\")\n}$"
            compile(self)
            
        }
        
        if row == 6 {
            
            enteredCode.text = "{\n\tstring s\n\ts = \"\"\n}$"
            compile(self)
            
        }
        
        if row == 7 {
            
            enteredCode.text = "{\n\tstring s\n\ts = \"abcde\"\n}$"
            compile(self)
            
        }
        
        if row == 8 {
            
            enteredCode.text = "{\n\tint a\n\ta = 4\n\n\tint b\n\tb = 2 + a\n}$"
            compile(self)
            
        }
        
        if row == 9 {
            
            enteredCode.text = "{\n\tif true {\n\t\tint a\n\t\ta = 1\n\t}\n}$"
            compile(self)
            
        }
        
        if row == 10 {
            
            enteredCode.text = "{\n\tboolean b\n\tb = true\n\tb = false\n}$"
            compile(self)
            
        }
        
        if row == 11 {
            
            enteredCode.text = "{\n\tint x\n\tx = 0\n\n\twhile(x != 5)\n\t{\n\t\tprint(x)\n\t\tx = 1 + x\n\t}\n}$"
            compile(self)
            
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        compile(self)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
