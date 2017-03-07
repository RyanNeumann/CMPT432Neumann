//
//  ViewController.swift
//  Design Compiler
//
//  Created by Ryan Neumann on 2/12/17.
//  Copyright © 2017 RyanNeumann. All rights reserved.
//
import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate, NSComboBoxDelegate, NSComboBoxDataSource, NSTextViewDelegate {
    
    @IBOutlet weak var warningLabel: NSTextField!
    
    @IBOutlet var parsedList: NSTextView!
    
    @IBOutlet var enteredCode: NSTextView!
    
    @IBOutlet var tokenList: NSTextView!
    
    @IBOutlet var examplePicker: NSComboBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        examplePicker.dataSource = self
        examplePicker.delegate = self
        enteredCode.toggleAutomaticQuoteSubstitution(self)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func compileClicked(_ sender: Any) {
        
        
        //Compile button pressed and function activated.
        if enteredCode.string?.isEmpty == false {
            
            if textEntered == "" {
                
                textEntered = enteredCode.string!
                
            }
            
            //Used to clear the entered code and create an array that will be cycled through
            
            if enteredCode.string?.characters.first == "\""{
                
                inputText.append((enteredCode.string?.characters.first!)!)
                enteredCode.string?.characters.removeFirst()
                
                
                while (enteredCode.string?.characters.first != "\"") == true {
                    
                    if enteredCode.string?.characters.first == nil {
                    
                        break
                        
                    }
                    
                    inputText.append(enteredCode.string!.characters.first!)
                    enteredCode.string?.characters.removeFirst()
                    
                }
                
            }
            
            if enteredCode.string?.characters.first == "\""{
                
                inputText.append((enteredCode.string?.characters.first!)!)
                enteredCode.string?.characters.removeFirst()
                
                
            } else if enteredCode.string?.characters.first == " " {
                
                enteredCode.string?.characters.removeFirst()
                
            } else if enteredCode.string?.characters.first == nil {
            
            
            } else {
                
                inputText.append((enteredCode.string?.characters.first!)!)
                enteredCode.string?.characters.removeFirst()
                
            }
            
            finalList.removeAll(keepingCapacity: false)
            tokenList.string = ""
            cleanList.removeAll(keepingCapacity: false)
            compileClicked(self)
            
        } else {
            //CHECK IF EOP($) IS MISSING
            if inputText.last != "$" {
                
                inputText.append("$")
                warningLabel.stringValue = "Please use '$' to end the program! \n One has been added for you."
                enteredCode.string = textEntered.appending("$")
                
            } else {
                
                warningLabel.stringValue = ""
                enteredCode.string = textEntered
                
            }
            
            
            textEntered = ""
            errorCount = 0
            lineNumber = 0
            programNum = 1
            checkNext()
            
        }
        
    }
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        
        if examplePicker.indexOfSelectedItem == 0 {
            
            enteredCode.string = "{ }$"
            compileClicked(self)
            
        }
        
        if examplePicker.indexOfSelectedItem == 1 {
            
            enteredCode.string = "{\n\tint x\n\tstring s\n\tboolean b\n}$"
            compileClicked(self)
            
        }
        
        if examplePicker.indexOfSelectedItem == 2 {
            
            enteredCode.string = "{\n\tint a\n\ta = 1\n}$"
            compileClicked(self)
            
        }
        
        if examplePicker.indexOfSelectedItem == 3 {
            
            enteredCode.string = "{\n\tint a\n\ta = 1\n\n\tint b\n\tb = 2\n\n\ta = b\n\tb = a\n}$"
            compileClicked(self)
            
        }
        
        if examplePicker.indexOfSelectedItem == 4 {
            
            enteredCode.string = "{\n\tprint(1)\n}$"
            compileClicked(self)
            
        }
        
        if examplePicker.indexOfSelectedItem == 5 {
            
            enteredCode.string = "{\n\tprint(\"hello world\")\n}$"
            compileClicked(self)
            
        }
        
        if examplePicker.indexOfSelectedItem == 6 {
            
            enteredCode.string = "{\n\tstring s\n\ts = \"\"\n}$"
            compileClicked(self)
            
        }
        
        if examplePicker.indexOfSelectedItem == 7 {
            
            enteredCode.string = "{\n\tstring s\n\ts = \"abcde\"\n}$"
            compileClicked(self)
            
        }

        
        if examplePicker.indexOfSelectedItem == 8 {
            
            enteredCode.string = "{\n\tif true {\n\t\tint a\n\t\ta = 1\n\t}\n}$"
            compileClicked(self)
            
        }
        
        if examplePicker.indexOfSelectedItem == 9 {
            
            enteredCode.string = "{\n\tboolean b\n\tb = true\n\tb = false\n}$"
            compileClicked(self)
            
        }
        
        if examplePicker.indexOfSelectedItem == 10 {
            
            enteredCode.string = "{\n\tint x\n\tx = 0\n\n\twhile(x != 5)\n\t{\n\t\tprint(x)\n\t\tx = 1 + x\n\t}\n}$"
            compileClicked(self)
            
        }
        
    }
    
    var exampleTokens = ["Example 1: Minimal", "Example 2: Declaration", "Example 3: Assignment 1", "Example 4: Assignment 2", "Example 5: Print 1", "Example 6: Print 2", "Example 7: String 1", "Example 8: String 2", "Example 9: If Statement", "Example 10: Boolean", "Example 11: While"]
    
    
    
    
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
