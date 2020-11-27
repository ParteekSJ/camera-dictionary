//
//  PreviousCell.swift
//  CameraDictionary
//
//  Created by Parteek Singh on 4/24/20.
//  Copyright © 2020 ParteekSJ. All rights reserved.
//

import Foundation
import UIKit

class PreviousCell: UITableViewCell {
    
    @IBOutlet var prevWordLbl: UILabel!
    
    func setPrevWord(prevWord : PrevWord) {
        self.prevWordLbl.text = prevWord.word
    }
}
