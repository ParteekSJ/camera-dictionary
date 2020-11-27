//
//  MainVC.swift
//  CameraDictionary
//
//  Created by Parteek Singh on 4/24/20.
//  Copyright © 2020 ParteekSJ. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToMain(unwindSegue : UIStoryboardSegue){
       }
    
    
    @IBAction func scanWordsWasPressed(_ sender: Any) {
        performSegue(withIdentifier: "toVisionVC", sender: self)
    }
    
    
    
    @IBAction func viewPastWordsBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toPrevScanned", sender: self)
    }
    
    
    
    
    
    
}
