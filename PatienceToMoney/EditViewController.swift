//
//  EditViewController.swift
//  PatienceToMoney
//
//  Created by 松山響也 on 2020/06/10.
//  Copyright © 2020 Kyoya Matsuyama. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class EditViewController: UIViewController,UITextFieldDelegate {

    let db = Firestore.firestore()
    var titleString = String()
    var moneyString = String()
    var descriptionString = String()
    var documentId = String()
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = titleString
        moneyTextField.text = moneyString
        descriptionTextField.text = descriptionString
        moneyTextField.keyboardType = UIKeyboardType.numberPad

    }
    
    @IBAction func edit(_ sender: Any) {
        let title = titleTextField.text
        let money = Int(moneyTextField.text!)
        let description = descriptionTextField.text
        let data = ["title":title,"money":money,"description":description] as [String : Any]
        var ref: DocumentReference? = nil
        ref = db.collection("patients").document("\(documentId)")
        ref?.updateData(data as [AnyHashable : Any]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        let indexVC = self.storyboard?.instantiateViewController(identifier: "index") as! IndexViewController
        indexVC.modalPresentationStyle = .fullScreen
        present(indexVC, animated: true, completion: nil)

        
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

}
