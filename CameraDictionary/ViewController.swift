//
//  ViewController.swift
//  CameraDictionary
//
//  Created by Parteek Singh on 4/4/20.
//  Copyright © 2020 ParteekSJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var x = "helo"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func isCorrect(word : String)->Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.count)
        let wordRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return wordRange.location == NSNotFound
    }
    
    // Method to check spelling.
    func suggestUpdate() {
        
        // Declaration of UITextChecker.
        let checker : UITextChecker = UITextChecker()
        
        // Get the number of characters in text.
        let length = x.count
        
        // Specify the spelling range (0 ~ number of entered characters).
        let checkRange: NSRange = NSMakeRange(0, x.count)
        
        // Look for things with wrong spelling from the range.
        let misspelledRange: NSRange = checker.rangeOfMisspelledWord(
            
            // Specify the character to check.
            in: x,
            
            // Specify the range to check.
            range: checkRange,
            
            // Specify the start position as the beginning of the range.
            startingAt: checkRange.location,
            
            // Even if no mistakes are found within the specified range start searching from the range start position (false hold the end position where no mistakes were found)
            wrap: true,
            
            // Specify language as English.
            language: "en_US")
        
        // If a misspelling is found.
        if misspelledRange.location != NSNotFound {
            
            // Obtain correct spelling candidates.
            let candidateArray: [String] = checker.guesses(
                
                // The range where there is a misspelling.
                forWordRange: misspelledRange,
                
                // Characters containing misspellings (in range).
                in: x,
                
                // Specify the language.
                language: "en_US")!
            
            var str = "By any chance:\n"
            
            // Retrieve the candidates one by one from the array.
            for text in candidateArray {
                str += text.description
                str += ", "
            }
            print(str)
        }
    }

    
        
    //    if isCorrect(word: x) {
     //       print("Correct")
     //   } else {
     //       print("Wrong")
     //   }
//
     //   suggestUpdate()
    
    
    

}

