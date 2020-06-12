//
//  DetailViewController.swift
//  PatienceToMoney
//
//  Created by 松山響也 on 2020/06/10.
//  Copyright © 2020 Kyoya Matsuyama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class DetailViewController: UIViewController {

    var titleString = String()
    var moneyString = String()
    var descriptionString = String()
    var sumMoneyString = String()
    var documentIdString = String()
    
    @IBOutlet weak var sumMoneyLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sumMoney: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleString
        moneyLabel.text = moneyString
        descriptionLabel.text = descriptionString
        sumMoneyLabel.text = sumMoneyString
        print(moneyLabel.text)
        print("確認")
    }
    
    
    @IBAction func toEdit(_ sender: Any) {
        performSegue(withIdentifier:"toEdit" , sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editVC = segue.destination as! EditViewController
        editVC.titleString = titleString
        editVC.moneyString = moneyString
        editVC.descriptionString = descriptionString
        editVC.documentIdString = documentIdString
    }
    
    @IBAction func deletePatience(_ sender: Any) {
        let db = Firestore.firestore()
        let ref:DocumentReference? = nil
        db.collection("patiences").document(documentIdString).delete(completion: { (error) in
            if error != nil {
            }else{
                let indexVC = self.storyboard?.instantiateViewController(withIdentifier: "index") as! IndexViewController
                indexVC.modalPresentationStyle = .fullScreen
                self.present(indexVC, animated: true, completion: nil)
            }
        })
    }

    @IBAction func patience(_ sender: Any) {
        var resultMoney = Int(sumMoneyString)!
        let patienceMoney = Int(moneyLabel.text!)!
        resultMoney = resultMoney + patienceMoney
        UserDefaults.standard.set("\(resultMoney)", forKey: "sumMoney")
        addPatience()
        dismiss(animated: true, completion: nil)
    }
    
    func addPatience(){
        print("追加されています")
        let dt = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options:0, locale:Locale(identifier: "ja_JP"))
        let data = ["title":titleString,"money":moneyString,"description":descriptionString,"created_at":dateFormatter.string(from: dt),"uid":Auth.auth().currentUser!.uid]
        let db = Firestore.firestore()
        db.collection("patiencesHistory").addDocument(data: data)
    }
    

    
    
}
