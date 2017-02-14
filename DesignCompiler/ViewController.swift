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
    
    @IBOutlet var tokenList: UITextView!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var compileButton: UIButton!
    
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
