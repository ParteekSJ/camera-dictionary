//
//  ScannedWordVC.swift
//  CameraDictionary
//
//  Created by Parteek Singh on 4/5/20.
//  Copyright © 2020 ParteekSJ. All rights reserved.
//

import UIKit
import RealmSwift

typealias JSON = [String:Any]

class ScannedWordVC: UIViewController {

    @IBOutlet var wordLbl: UILabel!
    @IBOutlet var tableView: UITableView!
    var scannedword : String = ""
    
    let defaults = UserDefaults.standard
    var meaning = [Meaning]()
    
    let realm = try! Realm()

    
    
    @IBAction func unwindFromScannedWord(unwindSegue : UIStoryboardSegue){
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableView.automaticDimension
        getMeaning()
        wordLbl.text = scannedword
        print("WORD IS : \(scannedword)")
          
       
        
    }
    
 func getMeaning() {
        wordLbl.text = scannedword.lowercased()
        let wordFirstAlphabet = scannedword.prefix(1).lowercased()
        guard let path = Bundle.main.path(forResource: wordFirstAlphabet, ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)

        do{
            var wordObject = Word(word: scannedword)

            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options:[])
            
            guard let JSON = json as? [String : Any] else {return}
            guard let def = JSON[scannedword.lowercased()] as? JSON else {return}
    
            guard let meanings = def["meanings"] as? [JSON] else {return}
            
            var pointer = 0
            var indexnumber = 1
            
            for x in meanings {
                guard let defintion = meanings[pointer]["def"] as? String else {return}
                pointer=pointer+1
                
                let def = ("\(indexnumber).  \(defintion)")
                var meaningArr = Meaning(def : def)
                print(def)
                indexnumber = indexnumber + 1
                meaning.append(meaningArr)
            }
            
            //Saving Data to the Realm Database
            let prevWord = PrevWord()
            prevWord.word = scannedword
            realm.beginWrite()
            realm.add(prevWord)
            try! realm.commitWrite()
                    
            

        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}

extension ScannedWordVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meaning.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let m = meaning[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "meaningCell") as! MeaningCell
        cell.setMeaning(MeaningObj: m)
        return cell
    }

    
}
