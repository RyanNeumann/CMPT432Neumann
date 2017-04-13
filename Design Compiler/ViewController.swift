//
//  ViewController.swift
//  Design Compiler
//
//  Created by Ryan Neumann on 2/12/17.
//  Copyright © 2017 RyanNeumann. All rights reserved.
//
import Cocoa

var exampleTokens = ["Example 1: Minimal", "Example 2: Declaration", "Example 3: Assignment 1", "Example 4: Assignment 2", "Example 5: Print 1", "Example 6: Print 2", "Example 7: String 1", "Example 8: String 2", "Example 9: If Statement", "Example 10: Boolean", "Example 11: While"]

class ViewController: NSViewController, NSTextFieldDelegate, NSComboBoxDelegate, NSComboBoxDataSource, NSTextViewDelegate {
    
    @IBOutlet weak var warningLabel: NSTextField!
    
    @IBOutlet var parsedList: NSTextView!
    
    @IBOutlet var codeBox: NSTextField!
    
    @IBOutlet var enteredCode: NSTextFieldCell!
    
    //@IBOutlet var enteredCode: NSTextView!
    
    @IBOutlet var astFinal: NSTextView!
    
    @IBOutlet var tokenList: NSTextView!
    
    @IBOutlet var symbolList: NSTextView!
    
    @IBOutlet var examplePicker: NSComboBox!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        symbolList.font = NSFont(name: "Tahoma", size: 14)
        parsedList.font = NSFont(name: "Tahoma", size: 14)
        enteredCode.font = NSFont(name: "Tahoma", size: 20)
        tokenList.font = NSFont(name: "Tahoma", size: 14)
        astFinal.font = NSFont(name: "Tahoma", size: 14)
        examplePicker.dataSource = self
        examplePicker.delegate = self
        
        
    }
    
    @IBAction func compileClicked(_ sender: Any) {

        errorArray = []
        scopeErrors = 0
        parseError = 0
        symbolList.string = ""
        symbolTable = []
        symbolScope = []
        symbolType = []
        test = [:]
        errorArray = []
        symbolName = []
        lineNums = []
        scopeTracker = 0
        errorCounter = 0
        cst = []
        astList = []
        astFinal.string = ""
        astIndent = 0
        parseCount = 0
        programNum = 0
        currentLine = 1
        braceCounter = []
        currentBrace = 0
        
        //Compile button pressed and function activated.
        
        if self.enteredCode.stringValue.isEmpty == false {
            
            if textEntered == "" {
                
                textEntered = self.enteredCode.stringValue
                
            }
            //Used to clear the entered code and create an array that will be cycled through
            
            if self.enteredCode.stringValue.characters.first == "\""{
                
                inputText.append((self.enteredCode.stringValue.characters.first!))
                self.enteredCode.stringValue.characters.removeFirst()
                
                
                while (self.enteredCode.stringValue.characters.first != "\"") == true {
                    
                    if self.enteredCode.stringValue.characters.first == nil {
                    
                        break
                        
                    }
                    
                    inputText.append(self.enteredCode.stringValue.characters.first!)
                    self.enteredCode.stringValue.characters.removeFirst()
                    
                }
                
            }
            
            if self.enteredCode.stringValue.characters.first == "\""{
                
                inputText.append((self.enteredCode.stringValue.characters.first!))
                self.enteredCode.stringValue.characters.removeFirst()
                
            } else if self.enteredCode.stringValue.characters.first == " " {
                
                self.enteredCode.stringValue.characters.removeFirst()
                
            } else if self.enteredCode.stringValue.characters.first == nil {
                //Do nothing
            } else {
                
                inputText.append((self.enteredCode.stringValue.characters.first!))
                self.enteredCode.stringValue.characters.removeFirst()
                
            }
            
            finalList = []
            cleanList.removeAll(keepingCapacity: false)
            self.parsedList.string = ""
            self.compileClicked(self)
            
        } else {
            //CHECK IF EOP($) IS MISSING
            if inputText.last != "$"  && inputText.last != "\n" && inputText.last != " " && inputText.last != "\t" {
                
                inputText.append("$")
                self.warningLabel.stringValue = "Please use '$' to end the program!"
                self.enteredCode.stringValue = textEntered
                
            } else {
                
                self.warningLabel.stringValue = ""
                self.enteredCode.stringValue = textEntered
                
            }
            
            textEntered = ""
            errorCount = 0
            self.checkNext()
            finalList = [""]
            
        }
        
    }
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        
        if examplePicker.indexOfSelectedItem == 0 {
            
            enteredCode.stringValue = "{ }$"
            compileClicked(self)
            
        }
        
        if examplePicker.indexOfSelectedItem == 1 {
            
            enteredCode.stringValue = "{\n\tint x\n\tstring s\n\tboolean b\n}$"
            compileClicked(self)
            
        }
        
        if examplePicker.indexOfSelectedItem == 2 {
            
            enteredCode.stringValue = "{\n\tint a\n\ta = 1\n}$"
            compileClicked(self)
            
        }
        
        if examplePicker.indexOfSelectedItem == 3 {
            
            enteredCode.stringValue = "{\n\tint a\n\ta = 1\n\n\tint b\n\tb = 2\n\n\ta = b\n\tb = a\n}$"
            compileClicked(self)
            
        }
        
        if examplePicker.indexOfSelectedItem == 4 {
            
            enteredCode.stringValue = "{\n\tprint(1)\n}$"
            compileClicked(self)
            
        }
        
        if examplePicker.indexOfSelectedItem == 5 {
            
            enteredCode.stringValue = "{\n\tprint(\"hello world\")\n}$"
            compileClicked(self)
            
        }
        
        if examplePicker.indexOfSelectedItem == 6 {
            
            enteredCode.stringValue = "{\n\tstring s\n\ts = \"\"\n}$"
            compileClicked(self)
            
        }
        
        if examplePicker.indexOfSelectedItem == 7 {
            
            enteredCode.stringValue = "{\n\tstring s\n\ts = \"abcde\"\n}$"
            compileClicked(self)
            
        }

        
        if examplePicker.indexOfSelectedItem == 8 {
            
            enteredCode.stringValue = "{\n\tif true {\n\t\tint a\n\t\ta = 1\n\t}\n}$"
            compileClicked(self)
            
        }
        
        if examplePicker.indexOfSelectedItem == 9 {
            
            enteredCode.stringValue = "{\n\tboolean b\n\tb = true\n\tb = false\n}$"
            compileClicked(self)
            
        }
        
        if examplePicker.indexOfSelectedItem == 10 {
            
            enteredCode.stringValue = "{\n\tint x\n\tx = 0\n\n\twhile(x != 5)\n\t{\n\t\tprint(x)\n\t\tx = 1 + x\n\t}\n}$"
            compileClicked(self)
            
        }
        
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
      
        return exampleTokens[index]
    }
    
    func numberOfItems(in aComboBox: NSComboBox) -> Int{
        
        return 11
    }


    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    
    }
    
}
