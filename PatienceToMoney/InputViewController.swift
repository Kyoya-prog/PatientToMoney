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
    
    let db = Firestore.firestore()

    let firebase = Firebase()
    var uid = String()
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uid = Auth.auth().currentUser!.uid
        moneyTextField.keyboardType = UIKeyboardType.numberPad

        // Do any additional setup after loading the view.
    }
    
    @IBAction func register(_ sender: Any) {
    
        let title = titleTextField.text!
        let money = Int(moneyTextField.text!)
        let descriotionString = descriptionTextField.text!
        
        insertData(title: title, money: money!, description:descriotionString, uid:uid )
        
        let indexVC = (self.storyboard?.instantiateViewController(identifier: "index"))! as IndexViewController
        present(indexVC, animated: true, completion: nil)
        
        
        
    }
    func insertData(title:String,money:Int,description:String,uid:String) {
        var ref: DocumentReference? = nil
        ref = db.collection("patients").addDocument(data: ["title": title,"money":money,"description":description,"uid":uid]){ err in
            if let err = err {
                print("Error adding document: \(err)")
                print("失敗しました！")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                print("成功しました！")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        moneyTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.resignFirstResponder()
        moneyTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
