//
//  GuessNumberViewController.swift
//  guessNumbergameTableView
//
//  Created by  Terry on 2017/6/2.
//  Copyright © 2017年 Terry. All rights reserved.
//

import UIKit

class GuessNumberViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var switchSegmentedControll: UISegmentedControl!
    @IBOutlet weak var guess: UIButton!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var tableView:UITableView!
    var isMultipe = false
    var a = 0
    var b = 0
    var guessList:[(guessNumber: String, isSelected: Bool)] = []
    var list = [ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    func randomFunc(){
        for index in 0...list.count - 1 {
            let pos = Int(arc4random()) % list.count
            if index != pos{
                swap(&list[index],&list[pos])
            }
        }
        print(list)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        randomFunc()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchSegmentedAction(_ sender: Any) {
        guessList = []
        tableView.reloadData()
        switch switchSegmentedControll.selectedSegmentIndex {
        // set all isSelected false
        case 0:
            isMultipe = false //single choice
        case 1:
            isMultipe = true // multiple choice
        default:
            break
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guessList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     //   print("cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! RecordTableViewCell
        cell.recordLabel.text = guessList[indexPath.row].guessNumber
//        if guessList[indexPath.row].isSelected
//        {
//            cell.accessoryType = .checkmark
//        } else
//        {
//            cell.accessoryType = .none
//        }
//        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! RecordTableViewCell
        
        //        if let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell")
        //        {
        //            if cell.accessoryType != .checkmark
        //            {
        //                cell.accessoryType = .checkmark
        //            } else
        //            {
        //                cell.accessoryType = .none
        //            }
        //        }
        //
        //print("didSelectRowAt")
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            
            if isMultipe == false {
                //single choice
                
                for i in 0 ... guessList.count - 1 {
                    if i != indexPath.row{
                        if guessList[i].isSelected == true
                        {
                            guessList[i].isSelected = false
                            cell.accessoryType = .none
                        }
                    }
                }
            }
            if guessList[indexPath.row].isSelected{
                cell.accessoryType = .none
                guessList[indexPath.row].isSelected = false
            }
            else{
                cell.accessoryType = .checkmark
                guessList[indexPath.row].isSelected = true
            }
        }
        tableView.reloadData()
        
        //print("before")
        //tableView.deselectRow(at: indexPath, animated: false)
        //print("after")
        
    }
    @IBAction func guessButton(_ sender: UIButton) {
        a = 0
        b = 0
        numberTextField.resignFirstResponder()
        if let inputString = numberTextField.text{
            numberTextField.text = ""
            if inputString.characters.count != 4 {
                let alertMessage = UIAlertController(title: "Oop", message: "please enter a 4-digit number", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertMessage.addAction(alertAction)
                present(alertMessage,animated:true,completion: {
                    self.numberTextField.becomeFirstResponder()})
            } else
            {   // 4-digit number count a and b
                for i in 0 ... 3 {
                    for j in 0 ... (inputString.characters.count) - 1 {
                        if list[i] == inputString.substring(with: j..<j+1){
                            if i == j {
                                a = a + 1
                            } else {
                                b = b + 1
                            }
                        }
                    }
                }
                
                guessList.insert((inputString + " a = \(a), b = \(b) \r\n", false), at: 0)
                tableView.reloadData()
                if a == 4 {
                    let alertMessage = UIAlertController(title: "Success", message: "guess the number : " + inputString, preferredStyle: .actionSheet)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!)->Void in
                        self.initialLabel.text = "????"
                        //self.answerLabel.text = ""
                        //prsent is before the alertAction handler
                        //print("alertAction")
                        self.tableView.reloadData()
                    })
                    alertMessage.addAction(alertAction)
                    present(alertMessage,animated: true,completion: {
                        self.randomFunc()
                        self.guessList = []
                        self.initialLabel.text = inputString
                        //print("present")
                    })
                }
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
