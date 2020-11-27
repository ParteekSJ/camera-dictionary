//
//  PreviousWordsVC.swift
//  CameraDictionary
//
//  Created by Parteek Singh on 4/24/20.
//  Copyright © 2020 ParteekSJ. All rights reserved.
//

import UIKit
import RealmSwift

class PreviousWordsVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    var words = [String]()
    
    
    let realm = try! Realm()
    
    var samplearr = ["Nothing Found"]
    
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
        
        //Fetching the data
        let prevWords = realm.objects(PrevWord.self)
        for words in prevWords {
            let previousWord = words.word
            print(previousWord)
        }
    }
    

}


extension PreviousWordsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let prevWords = realm.objects(PrevWord.self)
        return prevWords.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let prevWords = realm.objects(PrevWord.self)
        let word = prevWords[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "previousCell") as! PreviousCell
        
        cell.setPrevWord(prevWord : word)
        return cell

    }

    
}
