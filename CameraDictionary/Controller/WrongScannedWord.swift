//
//  WrongScannedWord.swift
//  CameraDictionary
//
//  Created by Parteek Singh on 4/20/20.
//  Copyright © 2020 ParteekSJ. All rights reserved.
//

import UIKit

class WrongScannedWord: UIViewController {
    
    var wordsArr : [Word] = []
    var newWordsArr : [Word] = []
    
    var selectedWord : String = ""

    @IBOutlet var tableView: UITableView!
    
    @IBAction func unwindFromWScannedWordMeaning(unwindSegue : UIStoryboardSegue){
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
}

extension WrongScannedWord : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let word = wordsArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell") as! WordCell
        
        cell.setWord(wordObject: word)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWord = wordsArr[indexPath.row].wordTitle
        performSegue(withIdentifier: "toMeaningVC", sender: self)
        //Pass Data to CoreML model
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let WScannedWordMeaningVC = segue.destination as? WScannedWordMeaningVC {
            WScannedWordMeaningVC.selectedWord = selectedWord.lowercased()
        }
    }
    
    
}
