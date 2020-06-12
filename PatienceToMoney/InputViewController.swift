//
//  InputViewController.swift
//  PatienceToMoney
//
//  Created by 松山響也 on 2020/06/09.
//  Copyright © 2020 Kyoya Matsuyama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class InputViewController: UIViewController,UITextFieldDelegate {
    
    let firebase = Firebase()
    var uid = String()
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var inputButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = Auth.auth().currentUser!.uid
        moneyTextField.keyboardType = UIKeyboardType.numberPad
    }
    

    @IBAction func register(_ sender: Any) {
        if titleTextField.text == ""||moneyTextField.text == ""{
            inputButton.isEnabled = false
            alertLabel.text = "タイトルと貯金額は必須項目です"
        }else{
            let title = titleTextField.text!
            let money = moneyTextField.text!
            let descriotionString = descriptionTextField.text!
            insertData(title: title, money: money, description:descriotionString, uid:uid )
            let indexVC = (self.storyboard?.instantiateViewController(identifier: "index"))! as IndexViewController
            indexVC.modalPresentationStyle = .fullScreen
            present(indexVC, animated: true, completion: nil)
        }
    }
    
    func insertData(title:String,money:String,description:String,uid:String) {
        let db = Firestore.firestore()
        let ref = db.collection("patiences").addDocument(data: ["title": title,"money":money,"description":description,"uid":uid])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if titleTextField.text == ""||moneyTextField.text == ""{
            inputButton.isEnabled = false
        }else{
            inputButton.isEnabled = true
        }
        titleTextField.resignFirstResponder()
        moneyTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if titleTextField.text == ""||moneyTextField.text == ""{
            inputButton.isEnabled = false
        }else{
            inputButton.isEnabled = true
        }
        titleTextField.resignFirstResponder()
        moneyTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    }
}
