//
//  MeaningCell.swift
//  CameraDictionary
//
//  Created by Parteek Singh on 4/20/20.
//  Copyright © 2020 ParteekSJ. All rights reserved.
//

import Foundation
import UIKit

class MeaningCell: UITableViewCell {
    
    @IBOutlet var defLbl: UILabel!
    //@IBOutlet var speechpartLbl: UILabel!
    //@IBOutlet var exampleLbl: UILabel!
    
    func setMeaning(MeaningObj : Meaning) {
        defLbl.text = MeaningObj.def
        //speechpartLbl.text = MeaningObj.speechpart
        //exampleLbl.text = MeaningObj.example
    }
    
    
}
