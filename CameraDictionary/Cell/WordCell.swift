//
//  WordCell.swift
//  CameraDictionary
//
//  Created by Parteek Singh on 4/20/20.
//  Copyright © 2020 ParteekSJ. All rights reserved.
//

import UIKit

class WordCell: UITableViewCell {
    
    @IBOutlet var wordLbl: UILabel!
    
    func setWord(wordObject : Word) {
        wordLbl.text = wordObject.wordTitle
    }
    
    
}
